// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:touriso_agent/models/article.dart';
import 'package:touriso_agent/models/client.dart';
import 'package:touriso_agent/screens/home/blog/activities_tags_carousel.dart';
import 'package:touriso_agent/screens/home/blog/article_images_manager.dart';
import 'package:touriso_agent/screens/home/blog/sites_tags_carousel.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/functions.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class ArticleDetailsPage extends StatefulWidget {
  const ArticleDetailsPage({super.key, this.articleId});
  final String? articleId;

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final ValueNotifier<List<String>> imageUrlsNotifier = ValueNotifier([]);
  final ValueNotifier<List<XFile>> newImagesNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> siteIdsNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> activityIdsNotifier = ValueNotifier([]);

  final ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  final PageController pageController = PageController();

  setButtonState() {
    if (titleController.text.trim().isEmpty ||
        contentController.text.trim().isEmpty) {
      buttonEnabledNotifier.value = false;
    } else {
      buttonEnabledNotifier.value = true;
    }
  }

  @override
  void initState() {
    super.initState();

    // if (widget.article.id != null) {
    // }

    titleController.addListener(() {
      setButtonState();
    });
    contentController.addListener(() {
      setButtonState();
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO: likes, comments, analytics
    //TODO: Pageview for details and analytics, buttons at the top to navigate between

    if (widget.articleId == '0') {
      return const Center(child: Text('Nothing to show'));
    }

    return FutureBuilder<Article>(
      future: getArticleFromId(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Article article = snapshot.data!;

          titleController.text = article.title;
          contentController.text = article.content;
          imageUrlsNotifier.value = [...article.imageUrls];
          siteIdsNotifier.value = [...article.siteIds];
          activityIdsNotifier.value = [...article.activityIds];
          newImagesNotifier.value = [];

          return PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Article details',
                            style: titleMedium(context),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.articleId != '1' && widget.articleId != '0')
                          const SizedBox(width: 10),
                        if (widget.articleId != '1' && widget.articleId != '0')
                          TextButton.icon(
                            onPressed: () {
                              pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutQuint);
                            },
                            icon: const Icon(Icons.bar_chart_rounded),
                            label: const Text('View analytics'),
                          ),
                        if (widget.articleId != '1' && widget.articleId != '0')
                          const SizedBox(width: 10),
                        if (widget.articleId != '1' && widget.articleId != '0')
                          TextButton.icon(
                            onPressed: () {
                              showConfirmationDialog(
                                context,
                                message: 'Delete article?',
                                confirmFunction: () async {
                                  showLoadingDialog(context);
                                  try {
                                    for (String imageUrl in article.imageUrls) {
                                      await http.delete(Uri.parse(imageUrl));
                                    }

                                    await articlesCollection
                                        .doc(article.id)
                                        .delete();

                                    context.pop();
                                    context.go('/articles/0');
                                  } catch (e) {
                                    context.pop();
                                    showAlertDialog(context);
                                  }
                                },
                              );
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.red,
                              backgroundColor: Colors.red.withOpacity(.2),
                            ),
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete article'),
                          ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(height: 0),
                          SizedBox(
                            width: 700,
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                children: [
                                  CustomTextFormField(
                                    controller: titleController,
                                    hintText: 'Title',
                                  ),
                                  const SizedBox(height: 12),
                                  CustomTextFormField(
                                    controller: contentController,
                                    hintText: 'Content',
                                    minLines: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          ArticlesImagesManager(
                            imageUrlsNotifier: imageUrlsNotifier,
                            newImagesNotifier: newImagesNotifier,
                          ),
                          const SizedBox(height: 40),
                          SitesTagsCarousel(siteIdsNotifier: siteIdsNotifier),
                          const SizedBox(height: 40),
                          ActivitiesTagsCarousel(
                              activityIdsNotifier: activityIdsNotifier),
                          const SizedBox(height: 40),
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(right: 24.0),
                            child: StatefulLoadingButton(
                              buttonEnabledNotifier: buttonEnabledNotifier,
                              onPressed: () async {
                                try {
                                  List<String> newImageUrls = [];

                                  for (String imageUrl
                                      in imageUrlsNotifier.value) {
                                    if (imageUrl.contains('firebasestorage') &&
                                        article.imageUrls.contains(imageUrl)) {
                                      newImageUrls.add(imageUrl);
                                    } else if (imageUrl
                                            .contains('firebasestorage') &&
                                        !article.imageUrls.contains(imageUrl)) {
                                      http.delete(Uri.parse(imageUrl));
                                    }
                                  }

                                  // List<String> newImageUrls = [
                                  //   ...imageUrlsNotifier.value.where((element) =>
                                  //       element.contains('firebasestorage'))
                                  // ];

                                  // print(newImageUrls);

                                  for (XFile image in newImagesNotifier.value) {
                                    newImageUrls.add(
                                        await (await articlesImagesRef
                                                .child(getRandomString(10))
                                                .putData(
                                                    await image.readAsBytes()))
                                            .ref
                                            .getDownloadURL());
                                  }

                                  // print(newImageUrls);

                                  if (widget.articleId == '1') {
                                    DocumentReference articleReference =
                                        await articlesCollection.add(Article(
                                      dateTimePosted: DateTime.now(),
                                      title: titleController.text.trim(),
                                      content: contentController.text.trim(),
                                      imageUrls: [...newImageUrls],
                                      siteIds: siteIdsNotifier.value,
                                      activityIds: activityIdsNotifier.value,
                                    ).toMap());

                                    context
                                        .go('/articles/${articleReference.id}');
                                  } else {
                                    await articlesCollection
                                        .doc(article.id)
                                        .update(Article(
                                          dateTimePosted:
                                              article.dateTimePosted,
                                          lastEdited: DateTime.now(),
                                          title: titleController.text.trim(),
                                          content:
                                              contentController.text.trim(),
                                          imageUrls: [...newImageUrls],
                                          siteIds: siteIdsNotifier.value,
                                          activityIds:
                                              activityIdsNotifier.value,
                                        ).toMap());
                                  }

                                  showAlertDialog(
                                    context,
                                    icon: Icons.info_outline_rounded,
                                    iconColor: Colors.green,
                                    message: 'Saved!',
                                  );
                                } catch (e) {
                                  showAlertDialog(context);
                                }
                              },
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (widget.articleId != '1' && widget.articleId != '0')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Article Analytics',
                              style: titleMedium(context),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              pageController.previousPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeOutQuint);
                            },
                            icon: const Icon(Icons.info_outline_rounded),
                            label: const Text('View details'),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 0),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Views (${article.views.length})',
                              style: titleMedium(context),
                            ),
                            const SizedBox(height: 5),
                            ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => FutureBuilder(
                                future: getClientFromUid(article.views[index]),
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Text(snapshot.data!.name);
                                  }
                                  return Container();
                                },
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 5),
                              itemCount: article.views.length,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Likes (${article.likes.length})',
                              style: titleMedium(context),
                            ),
                            const SizedBox(height: 5),
                            ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => FutureBuilder(
                                future: getClientFromUid(article.likes[index]),
                                builder: (BuildContext context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Text(snapshot.data!.name);
                                  }
                                  return Container();
                                },
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 5),
                              itemCount: article.likes.length,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Comments (${article.comments.length})',
                              style: titleMedium(context),
                            ),
                            const SizedBox(height: 5),
                            ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => Column(
                                children: [
                                  FutureBuilder(
                                    future: getClientFromUid(
                                        article.comments[index].userId),
                                    builder: (BuildContext context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.done) {
                                        return Text(snapshot.data!.name);
                                      }
                                      return Container();
                                    },
                                  ),
                                  Text(article.comments[index].content),
                                ],
                              ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 5),
                              itemCount: article.comments.length,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator.adaptive());
      },
    );
  }

  Future<Article> getArticleFromId() async {
    if (widget.articleId == '1') {
      return Article(dateTimePosted: DateTime.now(), title: '', content: '');
    }

    DocumentSnapshot articleSnapshot =
        await articlesCollection.doc(widget.articleId).get();
    return Article.fromFirebase(
        articleSnapshot.data() as Map<String, dynamic>, articleSnapshot.id);
  }

  Future<Client> getClientFromUid(String uid) async {
    DocumentSnapshot clientSnapshot = await clientsCollection.doc(uid).get();

    return Client.fromFirebase(
        clientSnapshot.data() as Map<String, dynamic>, clientSnapshot.id);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    imageUrlsNotifier.dispose();
    siteIdsNotifier.dispose();
    activityIdsNotifier.dispose();

    newImagesNotifier.dispose();

    pageController.dispose();

    super.dispose();
  }
}
