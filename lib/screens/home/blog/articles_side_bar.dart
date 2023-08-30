import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:touriso_agent/models/article.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class ArticlesSideBar extends StatelessWidget {
  const ArticlesSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Articles', style: titleLarge(context)),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () {
                    // articleImagesList.value = [];

                    context.go('/articles/1');
                  },
                  child: const Text('Add article'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        const Divider(height: 0),
        Expanded(
          child: StreamBuilder(
            stream: articlesCollection
                .where('writerId', isEqualTo: uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              List<Article> articles = snapshot.data!.docs
                  .map((e) => Article.fromFirebase(
                      e.data() as Map<String, dynamic>, e.id))
                  .toList();

              return ListView.separated(
                itemCount: articles.length,
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider();
                },
                itemBuilder: (BuildContext context, int index) {
                  Article article = articles[index];

                  return GestureDetector(
                    onTap: () {
                      // articleImagesList.value = [];

                      context.go('/articles/${article.id}');
                    },
                    child: ArticleListTile(article: article),
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

class ArticleListTile extends StatelessWidget {
  const ArticleListTile({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: null,
      title: Text(article.title),
      subtitle: Text(DateFormat.yMMMEd().format(article.dateTimePosted)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
    );
  }
}
