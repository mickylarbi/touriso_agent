import 'package:flutter/material.dart';

class ArticleImage extends StatelessWidget {
  const ArticleImage({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imagePath,
      height: 100,
      width: 100,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) => child,
      loadingBuilder: (context, child, loadingProgress) =>
          loadingProgress == null
              ? child
              : Container(
                  alignment: Alignment.center,
                  width: 100,
                  child: const CircularProgressIndicator.adaptive(),
                ),
    );
  }
}
