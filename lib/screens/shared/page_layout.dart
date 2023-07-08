import 'package:flutter/material.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({
    super.key,
    required this.title,
    this.actions,
    this.body,
    this.showBackButton = false,
    this.sectioned = false,
  });
  final bool showBackButton;
  final String title;
  final List<Widget>? actions;
  final Widget? body;
  final bool sectioned;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[sectioned ? 200 : 50],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                if (showBackButton) const BackButton(),
                Text(
                  title,
                  style: headlineSmall(context),
                ),
                const Spacer(),
                if (actions != null) ...actions!
              ],
            ),
          ),
          Expanded(child: body ?? Container()),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  const Section({super.key, required this.child, this.titleText, this.actions});
  final Widget child;
  final String? titleText;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (titleText != null)
                Text(
                  titleText!,
                  style: titleLarge(context),
                ),
              const Spacer(),
              if (actions != null) ...actions!
            ],
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
