import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/models/site/site.dart';
import 'package:touriso_agent/screens/home/blog/site_card.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class SitesTagsCarousel extends StatefulWidget {
  const SitesTagsCarousel({super.key, required this.siteIdsNotifier});
  final ValueNotifier<List<String>> siteIdsNotifier;

  @override
  State<SitesTagsCarousel> createState() => _SitesTagsCarouselState();
}

class _SitesTagsCarouselState extends State<SitesTagsCarousel> {
  final ValueNotifier<List<Site>> sitesNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();

    sitesNotifier.addListener(() {
      widget.siteIdsNotifier.value = [...sitesNotifier.value.map((e) => e.id)];
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getArticleSites(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return ValueListenableBuilder(
            valueListenable: sitesNotifier,
            builder: (BuildContext context, value, Widget? child) {
              if (value.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: TextButton(
                    onPressed: () async {
                      Site? result = await showSitePicker();

                      if (result != null) {
                        sitesNotifier.value = [...value, result];
                      }
                    },
                    child: const Text('Tag sites'),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Tagged sites', style: titleSmall(context)),
                  ),
                  SizedBox(
                    height: 300,
                    child: Row(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(24),
                            scrollDirection: Axis.horizontal,
                            itemCount: value.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 20),
                            itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  showFormDialog(
                                    context,
                                    ListView(
                                      shrinkWrap: true,
                                      children: [
                                        IconTextButton(
                                          onPressed: () {
                                            List<Site> temp =
                                                sitesNotifier.value;
                                            temp.remove(value[index]);
                                            sitesNotifier.value = [...temp];
                                            context.pop();
                                          },
                                          color: Colors.red,
                                          icon: Icons.delete,
                                        ),
                                        const SizedBox(height: 20),
                                        Text(
                                          value[index].name,
                                          style: titleMedium(context),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(value[index].location),
                                        const SizedBox(height: 8),
                                        Text(
                                          value[index].description,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                        const SizedBox(height: 20),
                                        TextButton(
                                          onPressed: () async {
                                            Uri mapUri = Uri.https(
                                                'www.google.com',
                                                '/maps/search/', {
                                              'api': '1',
                                              'query':
                                                  '${value[index].geoLocation.latitude},${value[index].geoLocation.longitude}'
                                            });

                                            try {
                                              if (await canLaunchUrl(mapUri)) {
                                                await launchUrl(mapUri);
                                              } else {
                                                showAlertDialog(context);
                                              }
                                            } catch (e) {
                                              showAlertDialog(context);
                                            }
                                          },
                                          child: const Text('View on map'),
                                        ),
                                        const SizedBox(height: 20),
                                        SizedBox(
                                          height: 100,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount:
                                                value[index].imageUrls.length,
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return const SizedBox(width: 10);
                                            },
                                            itemBuilder: (BuildContext context,
                                                int idx) {
                                              return Image.network(
                                                value[index].imageUrls[idx],
                                                height: 100,
                                                fit: BoxFit.cover,
                                                frameBuilder: (context,
                                                        child,
                                                        frame,
                                                        wasSynchronouslyLoaded) =>
                                                    child,
                                                loadingBuilder: (context, child,
                                                        loadingProgress) =>
                                                    loadingProgress == null
                                                        ? child
                                                        : const Center(
                                                            child:
                                                                CircularProgressIndicator
                                                                    .adaptive()),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                child: SiteCard(site: value[index])),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            Site? result = await showSitePicker();

                            if (result != null) {
                              sitesNotifier.value = [...value, result];
                            }
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        }

        return const CircularProgressIndicator.adaptive();
      },
    );
  }

  Future<void> getArticleSites() async {
    for (String siteId in widget.siteIdsNotifier.value) {
      DocumentSnapshot siteSnapshot = await sitesCollection.doc(siteId).get();

      sitesNotifier.value = [
        ...sitesNotifier.value,
        Site.fromFirebase(
          siteSnapshot.data() as Map<String, dynamic>,
          siteSnapshot.id,
        ),
      ];
    }
  }

  Future<T?> showSitePicker<T>() async {
    return showFormDialog(
      context,
      FutureBuilder<List<Site>>(
        future: getAllSites(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            List<Site> sites = snapshot.data!;

            sites.removeWhere(
                (element) => sitesNotifier.value.contains(element));

            sites.sort((a, b) => a.name.compareTo(b.name));

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select site', style: titleMedium(context)),
                const SizedBox(height: 12),
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: sites.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 40);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      Site site = sites[index];

                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, site);
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: site.imageUrls.isEmpty
                                  ? Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey,
                                    )
                                  : Image.network(
                                      site.imageUrls[0],
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                      frameBuilder: (context, child, frame,
                                              wasSynchronouslyLoaded) =>
                                          child,
                                      loadingBuilder: (context, child,
                                              loadingProgress) =>
                                          loadingProgress == null
                                              ? child
                                              : const Center(
                                                  child:
                                                      CircularProgressIndicator
                                                          .adaptive()),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(site.name),
                                  const SizedBox(height: 8),
                                  Text(
                                    site.location,
                                    style:
                                        const TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right)
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          return const CircularProgressIndicator.adaptive();
        },
      ),
    );
  }

  Future<List<Site>> getAllSites() async {
    QuerySnapshot sitesSnapshot = await sitesCollection.get();

    return sitesSnapshot.docs
        .map((e) => Site.fromFirebase(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }

  @override
  void dispose() {
    sitesNotifier.dispose();

    super.dispose();
  }
}
