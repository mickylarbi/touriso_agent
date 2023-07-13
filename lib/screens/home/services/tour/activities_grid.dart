import 'package:flutter/material.dart';
import 'package:touriso_agent/models/cduration.dart';
import 'package:touriso_agent/models/tour/activity.dart';
import 'package:touriso_agent/screens/shared/custom_grid.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class ActivitiesGrid extends StatelessWidget {
  const ActivitiesGrid({super.key, required this.siteId});
  final String siteId;

  @override
  Widget build(BuildContext context) {
    //TODO: future builder to get actvities with site id
    return CustomGrid(
      rowWidth: 4,
      children: List.generate(
        20,
        (index) => ActivityCard(
          activity: Activity(
            id: 'id',
            siteId: 'siteId',
            name: 'name',
            duration: CDuration(12,'minutes'),
            price: 145,
            description: 'description',
            imageUrls: const [],
          ),
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    //TODO: card thingy with image background
    //TODO: activity page
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Text(
            activity.name,
            style: bodyLarge(context),
          ),
          const SizedBox(height: 10),
          Text(
            activity.description,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}
