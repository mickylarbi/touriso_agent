import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ArticlesImagesManager extends StatefulWidget {
  const ArticlesImagesManager({
    super.key,
    required this.articleId,
  });
  final String? articleId;

  @override
  State<ArticlesImagesManager> createState() => _ArticlesImagesManagerState();
}

class _ArticlesImagesManagerState extends State<ArticlesImagesManager> {
  final ValueNotifier<List<XFile>> imagesNotifier = ValueNotifier([]);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24),
      child: TextButton(
        onPressed: () {},
        child: const Text('Add images'),
      ),
    );
  }

  @override
  void dispose() {
    imagesNotifier.dispose();

    super.dispose();
  }
}
