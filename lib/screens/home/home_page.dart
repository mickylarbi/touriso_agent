import 'package:flutter/material.dart';
import 'package:touriso_agent/screens/home/side_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}

