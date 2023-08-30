import 'package:flutter/material.dart';
import 'package:touriso_agent/models/article.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class ArticleAnalyticsPage extends StatelessWidget {
  const ArticleAnalyticsPage({super.key, required this.article});
  final Article article;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Article analytics',
                  style: titleMedium(context),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
