import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touriso_agent/models/site/activity.dart';
import 'package:touriso_agent/screens/home/services/site/activity/activity_form.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/screens/shared/custom_grid.dart';
import 'package:touriso_agent/screens/shared/empty_widget.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';
import 'package:touriso_agent/utils/constants.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class ActivityDetailsPage extends StatelessWidget {
  const ActivityDetailsPage({super.key, required this.activityId});
  final String activityId;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      showBackButton: true,
      sectioned: true,
      title: 'Activity',
      actions: [
        TextButton.icon(
          onPressed: () {
            showConfirmationDialog(
              context,
              message: 'Delete activity?',
              confirmFunction: () async {
                showLoadingDialog(context);
                try {
                  //delete activity document from firestore
                  await activitiesCollection.doc(activityId).delete();

                  //list activity images in storage
                  List<Reference> refs =
                      (await imagesRef(activityId).listAll()).items;
                  //delete listed images
                  for (Reference ref in refs) {
                    await ref.delete();
                  }

                  Navigator.pop(context);
                  context.pop();
                } catch (e) {
                  print(e);
                  showAlertDialog(context);
                }
              },
            );
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.red.withOpacity(.1),
            foregroundColor: Colors.red,
          ),
          icon: const Icon(Icons.delete),
          label: const Text('Delete activity'),
        )
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        child: Column(
          children: [
            activityDetailsSection(),
            const SizedBox(height: 40),
            activityImagesSection(),
          ],
        ),
      ),
    );
  }

  activityDetailsSection() {
    return StatefulBuilder(
      builder: (context, setState) {
        return FutureBuilder(
          future: activitiesCollection.doc(activityId).get(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const CustomErrorWidget();
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Activity activity = Activity.fromFirebase(
                  snapshot.data!.data() as Map<String, dynamic>,
                  snapshot.data!.id);

              return Section(
                titleText: activity.name,
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      showFormDialog(
                        context,
                        ActivityForm(
                          siteId: activity.siteId,
                          activity: activity,
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit details'),
                  ),
                ],
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
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
                          Text(
                            'Duration:',
                            style: bodySmall(context),
                          ),
                          Text(activity.duration.toString()),
                          const SizedBox(height: 20),
                          Text(
                            'Price:',
                            style: bodySmall(context),
                          ),
                          Text('$ghanaCedi ${activity.price.toString()}'),
                          if (activity.location != null)
                            const SizedBox(height: 20),
                          if (activity.location != null)
                            Text(
                              'Location:',
                              style: bodySmall(context),
                            ),
                          if (activity.location != null)
                            Text(activity.location!),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  activityImagesSection() => StatefulBuilder(
        builder: (context, setState) {
          return FutureBuilder(
            future: activitiesCollection.doc(activityId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: CustomErrorWidget());
              }

              if (snapshot.connectionState == ConnectionState.done) {
                List<String> imageUrls = Activity.fromFirebase(
                        snapshot.data!.data() as Map<String, dynamic>,
                        snapshot.data!.id)
                    .imageUrls;

                return Section(
                  titleText: 'Images',
                  actions: [
                    TextButton.icon(
                      onPressed: () async {
                        try {
                          final ImagePicker picker = ImagePicker();

                          XFile? pickedImage = await picker.pickImage(
                              source: ImageSource.gallery);

                          // ignore: use_build_context_synchronously
                          showLoadingDialog(context,
                              message: 'Uploading image');

                          TaskSnapshot p0 = await imagesRef(activityId)
                              .child(imageUrls.length.toString())
                              .putData(
                                await pickedImage!.readAsBytes(),
                                SettableMetadata(contentType: 'image/jpeg'),
                              );

                          // ignore: use_build_context_synchronously
                          Navigator.of(context, rootNavigator: true).pop();

                          // update database with download url
                          await activitiesCollection.doc(activityId).update({
                            'imageUrls': FieldValue.arrayUnion(
                                [await p0.ref.getDownloadURL()])
                          });

                          setState(() {});
                        } catch (e) {
                          print(e);
                          showAlertDialog(context);
                        }
                      },
                      icon: const Icon(Icons.add_photo_alternate_rounded),
                      label: const Text('Add image'),
                    ),
                  ],
                  child: CustomGrid(
                    rowWidth: 4,
                    children: imageUrls
                        .map((e) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  imageWidget(context, e, imageUrls, setState),
                            ))
                        .toList(),
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      );

  imageWidget(context, src, List<String> imageUrls, setState) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.transparent,
            clipBehavior: Clip.none,
            contentPadding: EdgeInsets.zero,
            content: Image.network(
              src,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                  child,
              loadingBuilder: (context, child, loadingProgress) =>
                  loadingProgress == null
                      ? child
                      : const Center(child: CircularProgressIndicator()),
            ),
            actions: [
              IconTextButton(
                onPressed: () {
                  List<String> temp = [...imageUrls];
                  temp.remove(src);

                  showConfirmationDialog(
                    context,
                    message: 'Delete image?',
                    confirmFunction: () async {
                      try {
                        showLoadingDialog(context);

                        await imagesRef(activityId)
                            .child(imageUrls.indexOf(src).toString())
                            .delete();

                        await activitiesCollection
                            .doc(activityId)
                            .update({'imageUrls': temp});

                        Navigator.pop(context);
                        Navigator.pop(context);

                        setState(() {});
                      } catch (e) {
                        print(e);
                        showAlertDialog(context);
                      }
                    },
                  );
                },
                color: Colors.red,
                icon: Icons.delete_outline_rounded,
              ),
            ],
          ),
        );
      },
      child: Image.network(
        src,
        height: 200,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => child,
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
                ? child
                : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

// class ImageWidget extends StatelessWidget {
//   const ImageWidget({
//     super.key,
//     required this.src,
//     required this.imageRef,
//   });
//   final String src;
//   final Reference imageRef;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             backgroundColor: Colors.transparent,
//             clipBehavior: Clip.none,
//             contentPadding: EdgeInsets.zero,
//             content: Image.network(
//               src,
//               frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
//                   child,
//               loadingBuilder: (context, child, loadingProgress) =>
//                   loadingProgress == null
//                       ? child
//                       : const Center(child: CircularProgressIndicator()),
//             ),
//             actions: [
//               IconTextButton(
//                 onPressed: () {
//                   showConfirmationDialog(
//                     context,
//                     message: 'Delete image?',
//                     confirmFunction: () {
//                       imageRef.delete();
//                     },
//                   );
//                 },
//                 color: Colors.red,
//                 icon: Icons.delete_outline_rounded,
//               ),
//             ],
//           ),
//         );
//       },
//       child: Image.network(
//         src,
//         height: 200,
//         fit: BoxFit.cover,
//         frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => child,
//         loadingBuilder: (context, child, loadingProgress) =>
//             loadingProgress == null
//                 ? child
//                 : const Center(child: CircularProgressIndicator()),
//       ),
//     );
//   }
// }
