import 'package:flutter/material.dart';

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
                  style: Theme.of(context).textTheme.headlineSmall,
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
  const Section({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(36),
      child: child,
    );
  }
}
