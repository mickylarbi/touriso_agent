import 'package:flutter/material.dart';
import 'package:touriso_agent/utils/colors.dart';

// ignore: must_be_immutable
class LoadingButton extends StatelessWidget {
  LoadingButton(
      {super.key,
      required this.onPressed,
      required this.child,
      this.backgroundColor,
      this.foregroundColor,
      this.minimumSize,
      this.shape});
  final Function onPressed;
  final Widget child;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Size? minimumSize;
  final OutlinedBorder? shape;

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) => ElevatedButton(
        onPressed: () async {
          isLoading = true;
          setState(() {});

          await onPressed();

          isLoading = false;
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          minimumSize: minimumSize ?? const Size.fromHeight(48),
          // backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
          // foregroundColor: foregroundColor,
          // padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: shape ??
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : child,
      ),
    );
  }
}

class MenuTextButton extends StatelessWidget {
  MenuTextButton(
      {super.key, required this.title, required this.items, this.onSelected});
  final String title;
  final List<PopupMenuEntry> items;
  final Function(dynamic)? onSelected;

  final GlobalKey<PopupMenuButtonState> menuStateKey =
      GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      key: menuStateKey,
      itemBuilder: (context) => items,
      onSelected: onSelected,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: TextButton(
        onPressed: () {
          menuStateKey.currentState!.showButtonMenu();
        },
        child: Text(title),
      ),
    );
  }
}

class IconTextButton extends StatelessWidget {
  const IconTextButton(
      {super.key, required this.icon, this.color, this.onPressed});
  final IconData icon;
  final Color? color;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: (color ?? primaryColor).withOpacity(.1),
        foregroundColor: color,
        iconColor: color,
      ),
      child: const Icon(Icons.delete),
    );
  }
}
