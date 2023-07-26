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
                child: Container(
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.1),
                        blurRadius: 40,
                      ),
                    ],
                    image: const DecorationImage(
                      image: AssetImage('assets/images/homeimg-30 1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(child: child),
            ],
          ),
        ],
      ),
    );
  }
}
