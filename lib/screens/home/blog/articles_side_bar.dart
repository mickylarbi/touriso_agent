import 'package:flutter/material.dart';
import 'package:touriso_agent/models/article.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class ArticlesSideBar extends StatelessWidget {
  const ArticlesSideBar({super.key, required this.selectedArticleNotifier});

  final ValueNotifier<Article?> selectedArticleNotifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Articles', style: titleLarge(context)),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: () {
              selectedArticleNotifier.value =
                  Article(dateTime: DateTime.now(), title: '', content: '');
            },
            child: const Text('Add article'),
          ),
        ),
        const SizedBox(height: 20),
        const Divider(height: 0),
        Expanded(
          child: StreamBuilder(
            stream: articlesCollection.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              List<Article> articlesMapsList = snapshot.data!.docs
                  .map((e) => Article.fromFirebase(
                      e.data() as Map<String, dynamic>, e.id))
                  .toList();

              return ListView.separated(
                itemCount: articlesMapsList.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  Article articleMap = articlesMapsList[index];

                  return GestureDetector(
                    onTap: () {
                      selectedArticleNotifier.value = articleMap;
                    },
                    child: Row(
                      children: [
                        Column(
                          children: [],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
