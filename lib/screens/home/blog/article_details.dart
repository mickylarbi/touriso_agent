import 'package:flutter/material.dart';
import 'package:touriso_agent/models/article.dart';
import 'package:touriso_agent/screens/home/blog/article_images_manager.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class ArticleDetailsPage extends StatefulWidget {
  const ArticleDetailsPage({super.key, this.article});
  final Article? article;

  @override
  State<ArticleDetailsPage> createState() => _ArticleDetailsPageState();
}

class _ArticleDetailsPageState extends State<ArticleDetailsPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final ValueNotifier<List<String>> imageUrlsNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> siteIdsNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> activityIdsNotifier = ValueNotifier([]);

  final ValueNotifier<List<String>> buttonEnabledNotifier = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    //TODO: likes, comments, analytics
    if (widget.article == null) {
      return const Center(
        child: Text(
          'No details to show',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    bool isNew = widget.article!.id == null;

    return Column(
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
              if (!isNew)
                TextButton.icon(
                  onPressed: () {},
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
        ArticlesImagesManager(articleId: widget.article!.id),
      ],
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    imageUrlsNotifier.dispose();
    siteIdsNotifier.dispose();
    activityIdsNotifier.dispose();

    super.dispose();
  }
}
