import 'package:flutter/material.dart';
import 'package:touriso_agent/models/tour/site.dart';
import 'package:touriso_agent/screens/home/services/tour/activities_grid.dart';
import 'package:touriso_agent/screens/shared/empty_widget.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';

class SiteDetailsPage extends StatelessWidget {
  const SiteDetailsPage({super.key, required this.site});
  final Site site;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      showBackButton: true,
      sectioned: true,
      title: 'Site',
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
                  ? const EmptyWidget()
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
              child: const ActivitiesGrid(siteId: ''),
            )
          ],
        ),
      ),
    );
  }
}
