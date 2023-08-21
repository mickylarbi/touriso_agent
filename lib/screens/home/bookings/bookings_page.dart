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
import 'package:touriso_agent/utils/colors.dart';
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
  PageController pageController = PageController();
  int selectedIndex = 0;

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
              .toList();

          List<Booking> pendingBookings = bookings
              .where((element) => element.dateTime.isBefore(DateTime.now()))
              .toList();

          List<Booking> checkedInBookings =
              bookings.where((element) => element.checkedIn).
              toList();

          List<Booking> bookingsHistory = bookings
              .where((element) => element.dateTime.isAfter(DateTime.now()))
              .toList();

          List<String> tabs = ['Pending', 'Checked in', 'History'];

          return Column(
            children: [
              StatefulBuilder(
                  builder: (context, setState) => Container(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 12),
                        color: Colors.white,
                        child: Row(
                          children: List.generate(
                            tabs.length,
                            (index) => GestureDetector(
                              onTap: () {
                                selectedIndex = index;
                                pageController.jumpToPage(index);
                                setState(() {});
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 24),
                                decoration: selectedIndex == index
                                    ? const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: primaryColor, width: 2)))
                                    : null,
                                child: Text(
                                  tabs[index],
                                  style: selectedIndex == index
                                      ? const TextStyle(color: primaryColor)
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    bookingList(pendingBookings, 'Pending'),
                    bookingList(checkedInBookings, 'Checked in'),
                    bookingList(bookingsHistory, 'History'),
                  ],
                ),
              ),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  ListView bookingList(List<Booking> bookings, String titleText) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 100),
      children: [
        const SizedBox(height: 40),
        Text(
          titleText,
          style: titleLarge(context),
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
                                'Date',
                                'Client',
                                'Number of people',
                                'Activity',
                                'Site'
                              ],
                              textStyle: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 50),
                          ],
                        ),
                        Column(
                          children: List.generate(
                            bookings.length,
                            (index) => FutureBuilder(
                              future: getBookingDetails(bookings[index]),
                              builder: (context, AsyncSnapshot<List> snapshot) {
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
                                                radius: 10,
                                                backgroundImage: NetworkImage(
                                                    client.pictureUrl!),
                                              ),
                                      ),
                                      RowViewText(
                                        texts: [
                                          bookings[index].id,
                                          DateFormat.yMEd()
                                              .format(bookings[index].dateTime),
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
                                              message: 'Check client in?',
                                              confirmFunction: () async {
                                                await bookingsCollection
                                                    .doc(bookings[index].id)
                                                    .update(
                                                        {'checkedOut': true});

                                                setState(() {});
                                              },
                                            );
                                          },
                                          icon: const Icon(Icons.check_circle),
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
      ],
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

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }
}
