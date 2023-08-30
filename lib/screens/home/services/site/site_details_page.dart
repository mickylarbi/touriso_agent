import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touriso_agent/models/site/site.dart';
import 'package:touriso_agent/screens/home/services/site/activities_list.dart';
import 'package:touriso_agent/screens/home/services/site/activity/activity_form.dart';
import 'package:touriso_agent/screens/home/services/site/site_form.dart';
import 'package:touriso_agent/screens/shared/custom_grid.dart';
import 'package:touriso_agent/screens/shared/empty_widget.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/functions.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class SiteDetailsPage extends StatelessWidget {
  const SiteDetailsPage({super.key, required this.siteId});
  final String siteId;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      showBackButton: true,
      sectioned: true,
      title: 'Tourist Site',
      actions: [
        TextButton.icon(
          onPressed: () {
            showConfirmationDialog(
              context,
              message: 'Delete site?',
              confirmFunction: () async {
                showLoadingDialog(context);
                try {
                  //get sites from firestore
                  await sitesCollection.doc(siteId).delete();

                  //list site images in storage
                  List<Reference> refs =
                      (await imagesRef(siteId).listAll()).items;
                  //delete listed images
                  for (Reference ref in refs) {
                    await ref.delete();
                  }

                  //get site activities from firestore
                  List<QueryDocumentSnapshot<Object?>> activityDocs =
                      (await activitiesCollection
                              .where('siteId', isEqualTo: siteId)
                              .get())
                          .docs;
                  //delete listed activities
                  for (QueryDocumentSnapshot<Object?> activityDoc
                      in activityDocs) {
                    //delete activity document from firestore
                    await activitiesCollection.doc(activityDoc.id).delete();

                    //list activity images in storage
                    List<Reference> refs =
                        (await imagesRef(activityDoc.id).listAll()).items;
                    //delete listed images
                    for (Reference ref in refs) {
                      await ref.delete();
                    }
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
          label: const Text('Delete site'),
        )
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        child: Column(
          children: [
            siteDetailsSection(),
            const SizedBox(height: 40),
            sitesImagesSection(),
            const SizedBox(height: 40),
            Section(
              titleText: 'Activities',
              actions: [
                TextButton.icon(
                  onPressed: () {
                    showFormDialog(
                      context,
                      ActivityForm(siteId: siteId),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add activity'),
                ),
              ],
              child: ActivitiesList(siteId: siteId),
            ),
          ],
        ),
      ),
    );
  }

  siteDetailsSection() {
    return StatefulBuilder(builder: (context, setState) {
      return FutureBuilder(
        future: sitesCollection.doc(siteId).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const CustomErrorWidget();
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Site site = Site.fromFirebase(
                snapshot.data!.data() as Map<String, dynamic>,
                snapshot.data!.id);

            return Section(
              titleText: site.name,
              actions: [
                TextButton.icon(
                  onPressed: () {
                    showFormDialog(
                      context,
                      SiteForm(site: site),
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
                      site.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(color: Colors.grey, height: 1.5),
                    ),
                  ),
                  const SizedBox(width: 40),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Location:', style: bodySmall(context)),
                        Text(site.location),
                        const SizedBox(height: 20),
                        Text('Geo point:', style: bodySmall(context)),
                        Text(
                            '${site.geoLocation.latitude}, ${site.geoLocation.longitude}'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator.adaptive());
        },
      );
    });
  }

  sitesImagesSection() => StatefulBuilder(
        builder: (context, setState) {
          return FutureBuilder(
            future: sitesCollection.doc(siteId).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: CustomErrorWidget());
              }

              if (snapshot.connectionState == ConnectionState.done) {
                List<String> imageUrls = Site.fromFirebase(
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

                          TaskSnapshot p0 = await imagesRef(siteId)
                              .child(imageUrls.length.toString())
                              .putData(
                                await pickedImage!.readAsBytes(),
                                SettableMetadata(contentType: 'image/jpeg'),
                              );

                          // ignore: use_build_context_synchronously
                          Navigator.of(context, rootNavigator: true).pop();

                          // update database with download url
                          await sitesCollection.doc(siteId).update({
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
                                imageWidget(context, e, imageUrls, setState)))
                        .toList(),
                  ),
                );
              }

              return const Center(child: CircularProgressIndicator.adaptive());
            },
          );
        },
      );

  imageWidget(context, src, List<String> imageUrls, setState) {
    return InkWell(
      onTap: () {
        expandImage(context, src, () {
          List<String> temp = [...imageUrls];
          temp.remove(src);

          showConfirmationDialog(
            context,
            message: 'Delete image?',
            confirmFunction: () async {
              try {
                showLoadingDialog(context);

                await imagesRef(siteId)
                    .child(imageUrls.indexOf(src).toString())
                    .delete();

                await sitesCollection.doc(siteId).update({'imageUrls': temp});

                Navigator.pop(context);
                Navigator.pop(context);

                setState(() {});
              } catch (e) {
                print(e);
                showAlertDialog(context);
              }
            },
          );
        });
      },
      child: Image.network(
        src,
        height: 200,
        fit: BoxFit.cover,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => child,
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null
                ? child
                : const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

 
}
