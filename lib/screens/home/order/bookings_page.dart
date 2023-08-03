import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:touriso_agent/models/booking.dart';
import 'package:touriso_agent/models/client.dart';
import 'package:touriso_agent/models/site/activity.dart';
import 'package:touriso_agent/models/site/site.dart';
import 'package:touriso_agent/screens/shared/empty_widget.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';
import 'package:touriso_agent/screens/shared/row_view.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PageLayout(
      sectioned: true,
      title: 'Bookings',
      body: BookingsList(),
    );
  }
}

// class NewBookings extends StatefulWidget {
//   const NewBookings({super.key});

//   @override
//   State<NewBookings> createState() => _NewBookingsState();
// }

// class _NewBookingsState extends State<NewBookings> {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: bookingsCollection.where('companyId', isEqualTo: uid).get(),
//       builder: (BuildContext context, AsyncSnapshot snapshot) {
//         return ;
//       },
//     );
//   }
// }

class BookingsList extends StatefulWidget {
  const BookingsList({super.key});

  @override
  State<BookingsList> createState() => _BookingsListState();
}

class _BookingsListState extends State<BookingsList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: bookingsCollection.where('companyId', isEqualTo: uid).get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: CustomErrorWidget());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<Booking> bookings = snapshot.data!.docs
              .map((e) =>
                  Booking.fromFirebase(e.data() as Map<String, dynamic>, e.id))
              .where((element) => !element.checkedOut)
              .toList();

          List<Booking> checkedOutBookings = snapshot.data!.docs
              .map((e) =>
                  Booking.fromFirebase(e.data() as Map<String, dynamic>, e.id))
              .where((element) => element.checkedOut)
              .toList();

          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 100),
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  Text(
                    'Bookings',
                    style: headlineSmall(context),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 40),
              bookings.isEmpty
                  ? const Center(child: EmptyWidget())
                  : SizedBox(
                      height: (50 * bookings.length.toDouble()) + 50,
                      child: Section(
                        titlePadding: const EdgeInsets.all(0),
                        bodyPadding: const EdgeInsets.all(0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  SizedBox(width: 50),
                                  RowViewText(
                                    texts: [
                                      'Booking ID',
                                      'Client',
                                      'Date',
                                      'Number of people',
                                      'Activity',
                                      'Site'
                                    ],
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 50),
                                ],
                              ),
                              Column(
                                children: List.generate(
                                  bookings.length,
                                  (index) => FutureBuilder(
                                    future: getBookingDetails(bookings[index]),
                                    builder: (context,
                                        AsyncSnapshot<List> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        Activity activity = snapshot.data![0];
                                        Client client = snapshot.data![1];
                                        Site site = snapshot.data![2];

                                        return Row(
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: client.pictureUrl == null
                                                  ? const Icon(
                                                      Icons.person,
                                                      color: Colors.grey,
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(client
                                                              .pictureUrl!),
                                                    ),
                                            ),
                                            RowViewText(
                                              texts: [
                                                bookings[index].id,
                                                DateFormat.yMEd().format(
                                                    bookings[index].dateTime),
                                                client.name,
                                                bookings[index]
                                                    .numberOfPeople
                                                    .toString(),
                                                activity.name,
                                                site.name
                                              ],
                                            ),
                                            SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: IconButton(
                                                onPressed: () {
                                                  showConfirmationDialog(
                                                    context,
                                                    message: 'Check out?',
                                                    confirmFunction: () async {
                                                      await bookingsCollection
                                                          .doc(bookings[index]
                                                              .id)
                                                          .update({
                                                        'checkedOut': true
                                                      });

                                                      setState(() {});
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                    Icons.check_circle),
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      return Container();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              const SizedBox(height: 48),
              Row(
                children: [
                  Text(
                    'Checked Out',
                    style: headlineSmall(context),
                  ),
                  const Spacer(),
                ],
              ),
              checkedOutBookings.isEmpty
                  ? const Center(child: EmptyWidget())
                  : SizedBox(
                      height: (50 * checkedOutBookings.length.toDouble()) + 50,
                      child: Section(
                        titlePadding: const EdgeInsets.all(0),
                        bodyPadding: const EdgeInsets.all(0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  SizedBox(width: 50),
                                  RowViewText(
                                    texts: [
                                      'Booking ID',
                                      'Client',
                                      'Date',
                                      'Number of people',
                                      'Activity',
                                      'Site'
                                    ],
                                    textStyle:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 50),
                                ],
                              ),
                              Column(
                                children: List.generate(
                                  checkedOutBookings.length,
                                  (index) => FutureBuilder(
                                    future: getBookingDetails(
                                        checkedOutBookings[index]),
                                    builder: (context,
                                        AsyncSnapshot<List> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        Activity activity = snapshot.data![0];
                                        Client client = snapshot.data![1];
                                        Site site = snapshot.data![2];

                                        return Row(
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: client.pictureUrl == null
                                                  ? const Icon(
                                                      Icons.person,
                                                      color: Colors.grey,
                                                    )
                                                  : CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(client
                                                              .pictureUrl!),
                                                    ),
                                            ),
                                            RowViewText(
                                              texts: [
                                                checkedOutBookings[index].id,
                                                DateFormat.yMEd().format(
                                                    checkedOutBookings[index]
                                                        .dateTime),
                                                client.name,
                                                checkedOutBookings[index]
                                                    .numberOfPeople
                                                    .toString(),
                                                activity.name,
                                                site.name
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        );
                                      }

                                      return Container();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List> getBookingDetails(Booking booking) async {
    DocumentSnapshot activitySnapshot =
        await activitiesCollection.doc(booking.activityId).get();
    Activity activity = Activity.fromFirebase(
        activitySnapshot.data()! as Map<String, dynamic>, activitySnapshot.id);

    DocumentSnapshot siteSnapshot =
        await sitesCollection.doc(activity.siteId).get();
    Site site = Site.fromFirebase(
        siteSnapshot.data()! as Map<String, dynamic>, siteSnapshot.id);

    DocumentSnapshot clientSnapshot =
        await clientsCollection.doc(booking.clientId).get();
    Client client = Client.fromFirebase(
        clientSnapshot.data()! as Map<String, dynamic>, clientSnapshot.id);

    return [activity, client, site];
  }
}
