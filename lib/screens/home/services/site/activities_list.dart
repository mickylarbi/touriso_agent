import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/models/site/activity.dart';
import 'package:touriso_agent/screens/shared/empty_widget.dart';
import 'package:touriso_agent/screens/shared/row_view.dart';
import 'package:touriso_agent/utils/constants.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({super.key, required this.siteId});
  final String siteId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: activitiesCollection.where('siteId', isEqualTo: siteId).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: CustomErrorWidget());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<Activity> activities = snapshot.data!.docs
              .map((e) =>
                  Activity.fromFirebase(e.data() as Map<String, dynamic>, e.id))
              .toList();

          return Column(
            children: [
              if (activities.isNotEmpty)
                const RowViewText(
                  texts: [
                    'Name',
                    'Duration',
                    'Price',
                    'Location',
                    'Description',
                  ],
                  textStyle: TextStyle(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              ...activities.map((e) => InkWell(
                    onTap: () {
                      context.push('/services/site/$siteId/activity/${e.id}');
                    },
                    child: RowViewText(texts: [
                      e.name,
                      e.duration.toString(),
                      '$ghanaCedi ${e.price}',
                      e.location ?? '-',
                      e.description,
                    ]),
                  ))
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
