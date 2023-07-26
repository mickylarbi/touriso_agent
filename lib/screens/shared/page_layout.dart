import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/utils/colors.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class PageLayout extends StatelessWidget {
  const PageLayout({
    super.key,
    required this.title,
    this.actions,
    this.body,
    this.showBackButton = false,
    this.sectioned = false,
    this.appBarExtended = false,
    this.appBarExtension,
  });
  final bool showBackButton;
  final String title;
  final List<Widget>? actions;
  final Widget? body;
  final bool sectioned;
  final bool appBarExtended;
  final Widget? appBarExtension;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[sectioned ? 200 : 50],
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
              color: Colors.grey[50],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: [
                if (showBackButton)
                  BackButton(
                    onPressed: () {
                      context.pop();
                    },
                  ),
                Text(
                  title,
                  style: headlineSmall(context),
                ),
                const Spacer(),
                if (actions != null) ...actions!
              ],
            ),
          ),
          if (appBarExtended)
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
              child: appBarExtension!,
            ),
          Expanded(child: body ?? Container()),
        ],
      ),
    );
  }
}

class Section extends StatelessWidget {
  const Section({
    super.key,
    required this.child,
    this.titleText,
    this.actions,
    this.titlePadding = const EdgeInsets.only(top: 24, left: 36, right: 36),
    this.bodyPadding = const EdgeInsets.only(bottom: 24, left: 36, right: 36),
  });
  final Widget child;
  final String? titleText;
  final List<Widget>? actions;
  final EdgeInsetsGeometry titlePadding;
  final EdgeInsetsGeometry bodyPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: titlePadding,
            child: Row(
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
          ),
          if (titleText != null && actions != null) const SizedBox(height: 20),
          Padding(
            padding: bodyPadding,
            child: child,
          ),
        ],
      ),
    );
  }
}
