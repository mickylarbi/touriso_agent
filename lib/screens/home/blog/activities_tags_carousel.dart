import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/models/site/activity.dart';
import 'package:touriso_agent/models/site/site.dart';
import 'package:touriso_agent/screens/home/blog/activity_card.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/utils/constants.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/functions.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class ActivitiesTagsCarousel extends StatefulWidget {
  const ActivitiesTagsCarousel({super.key, required this.activityIdsNotifier});
  final ValueNotifier<List<String>> activityIdsNotifier;

  @override
  State<ActivitiesTagsCarousel> createState() => _ActivitiesTagsCarouselState();
}

class _ActivitiesTagsCarouselState extends State<ActivitiesTagsCarousel> {
  final ValueNotifier<List<Activity>> activitiesNotifier = ValueNotifier([]);

  @override
  void initState() {
    super.initState();

    activitiesNotifier.addListener(() {
      widget.activityIdsNotifier.value =
          activitiesNotifier.value.map((e) => e.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getArticleActivitys(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return ValueListenableBuilder(
            valueListenable: activitiesNotifier,
            builder: (BuildContext context, value, Widget? child) {
              if (value.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: TextButton(
                    onPressed: () async {
                      Activity? result = await showActivityPicker();

                      if (result != null) {
                        activitiesNotifier.value = [...value, result];
                      }
                    },
                    child: const Text('Tag activities'),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child:
                        Text('Tagged activities', style: titleSmall(context)),
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
                                        icon: Icons.delete,
                                        color: Colors.red,
                                        onPressed: () {
                                          List<Activity> temp =
                                              activitiesNotifier.value;

                                          temp.remove(value[index]);
                                          activitiesNotifier.value = [...temp];
                                          context.pop();
                                        },
                                      ),
                                      const SizedBox(height: 20),
                                      Text(
                                        value[index].name,
                                        style: titleMedium(context),
                                      ),
                                      const SizedBox(height: 8),
                                      FutureBuilder<Site>(
                                        future:
                                            getSiteFromId(value[index].siteId),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                                  ConnectionState.done &&
                                              snapshot.hasData) {
                                            return Text(snapshot.data!.name);
                                          }

                                          return Container();
                                        },
                                      ),
                                      const SizedBox(height: 8),
                                      Text(value[index].duration.toString()),
                                      const SizedBox(height: 8),
                                      Text('$ghanaCedi ${value[index].price}'),
                                      const SizedBox(height: 8),
                                      Text(
                                        value[index].description,
                                        style:
                                            const TextStyle(color: Colors.grey),
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
                                          itemBuilder:
                                              (BuildContext context, int idx) {
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
                              child: ActivityCard(activity: value[index]),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            Activity? result = await showActivityPicker();

                            if (result != null) {
                              activitiesNotifier.value = [...value, result];
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

  Future<void> getArticleActivitys() async {
    for (String activityId in widget.activityIdsNotifier.value) {
      DocumentSnapshot activitySnapshot =
          await activitiesCollection.doc(activityId).get();

      activitiesNotifier.value = [
        ...activitiesNotifier.value,
        Activity.fromFirebase(
          activitySnapshot.data() as Map<String, dynamic>,
          activitySnapshot.id,
        ),
      ];
    }
  }

  Future<T?> showActivityPicker<T>() async {
    return showFormDialog(
      context,
      FutureBuilder<List<Activity>>(
        future: getAllActivities(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.done) {
            List<Activity> activities = snapshot.data!;

            activities.removeWhere(
                (element) => activitiesNotifier.value.contains(element));

            activities.sort((a, b) => a.name.compareTo(b.name));

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Select activity', style: titleMedium(context)),
                const SizedBox(height: 12),
                Flexible(
                  fit: FlexFit.loose,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: activities.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(height: 40);
                    },
                    itemBuilder: (BuildContext context, int index) {
                      Activity activity = activities[index];

                      return InkWell(
                        onTap: () {
                          Navigator.pop(context, activity);
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: activity.imageUrls.isEmpty
                                  ? Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey,
                                    )
                                  : Image.network(
                                      activity.imageUrls[0],
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(activity.name),
                                  const SizedBox(height: 8),
                                  FutureBuilder<Site>(
                                    future: getSiteFromId(activity.siteId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        return Text(
                                          snapshot.data!.name,
                                          style: const TextStyle(
                                              color: Colors.black54),
                                        );
                                      }

                                      return Container();
                                    },
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

  Future<List<Activity>> getAllActivities() async {
    QuerySnapshot activitiesSnapshot = await activitiesCollection.get();

    return activitiesSnapshot.docs
        .map((e) =>
            Activity.fromFirebase(e.data() as Map<String, dynamic>, e.id))
        .toList();
  }

  @override
  void dispose() {
    activitiesNotifier.dispose();

    super.dispose();
  }
}
