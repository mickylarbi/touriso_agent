import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Opacity(
              opacity: .5,
              child: Image.asset(
                'assets/images/undraw_snap_the_moment_re_88cu 1.png',
                height: 100,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'No images to show',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
  }
}

