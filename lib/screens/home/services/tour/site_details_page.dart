import 'package:flutter/material.dart';
import 'package:touriso_agent/models/tour/activity.dart';
import 'package:touriso_agent/models/tour/site.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';

class SiteDetails extends StatelessWidget {
  const SiteDetails({super.key, required this.site});
  final Site site;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      sectioned: true,
      title: 'Site title',
      actions: const [],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        child: Column(
          children: [
            Section(
              titleText: 'Lou Moon',
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
                      site.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(color: Colors.grey, height: 1.5),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          site.location,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '(${site.geoLocation.latitude}, ${site.geoLocation.longitude}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
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
              child: site.imageUrls.isEmpty
                  ? Center(
                      child: Column(
                        children: [
                          Opacity(
                            opacity: .5,
                            child: Image.asset(
                              'assets/images/undraw_snap_the_moment_re_88cu 1.png',
                              height: 100,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'No images to show',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: site.imageUrls.length,
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
            const SizedBox(height: 40),
            Section(
              titleText: 'Activities',
              actions: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Add activity'),
                )
              ],
              child: Container(),
            )
          ],
        ),
      ),
    );
  }
}

class ActivitiesList extends StatelessWidget {
  const ActivitiesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text(activity.name),
              Text(activity.duration.toString()),
              Text('${activity.price}'),
              Text(activity.location),
            ],
          ),
        ),
        Expanded(child: Text(activity.description)),
        Expanded(
          child: GridView.builder(
            gridDelegate:
                SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 3),
            itemCount: 4,
            itemBuilder: (context, index) =>
                Image.asset(activity.imageUrls[index]),
          ),
        )
      ],
    );
  }
}
