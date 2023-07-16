import 'package:flutter/material.dart';
import 'package:touriso_agent/utils/dimensions.dart';

class AuthShell extends StatelessWidget {
  const AuthShell({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.png',
            width: kScreenWidth(context),
            fit: BoxFit.cover,
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/images/homeimg-30 1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(child: Center(child: child)),//TODO: move expanded and center into children
            ],
          ),
        ],
      ),
    );
  }
}
