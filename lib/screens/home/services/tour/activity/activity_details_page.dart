import 'package:flutter/material.dart';
import 'package:touriso_agent/models/tour/activity.dart';
import 'package:touriso_agent/screens/shared/empty_widget.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      showBackButton: true,
      sectioned: true,
      title: 'Activity',
      actions: [],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        child: Column(
          children: [
            Section(
              titleText: 'Snowboarding',
              actions: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit details'),
                ),
              ],
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      activity.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(color: Colors.grey, height: 1.5),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activity.duration.toString()),
                        const SizedBox(height: 20),
                        Text(activity.price.toString()),
                        if (activity.location != null)
                          const SizedBox(height: 20),
                        if (activity.location != null) Text(activity.location!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Section(
              titleText: 'Images',
              actions: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add image'),
                )
              ],
              child: activity.imageUrls.isEmpty
                  ? const EmptyWidget()
                  : SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: activity.imageUrls.length,
                        itemBuilder: (context, index) => Container(
                          color: Colors.green,
                          width: 100,
                        ),

                        // Image.network(
                        //   site.imageUrls[index],
                        //   fit: BoxFit.fitHeight,
                        // ),
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 15),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
