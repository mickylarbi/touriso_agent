import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/screens/home/side_bar.dart';
import 'package:touriso_agent/utils/colors.dart';
import 'package:touriso_agent/utils/constants.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key, required this.child});
  final Widget child;

  final GlobalKey<PopupMenuButtonState> _menuKey =
      GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Hero(
                    tag: kLogoTag,
                    child: Image.asset(
                      'assets/images/TOURISO 2.png',
                      height: 50,
                    ),
                  ),
                ),
                PopupMenuButton(
                  key: _menuKey,
                  itemBuilder: (context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      value: 'Settings',
                      child: Row(
                        children: [
                          Icon(Icons.settings),
                          SizedBox(width: 5),
                          Text('Settings'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'Log out',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 5),
                          Text('Log out'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'Log out') {
                      showConfirmationDialog(
                        context,
                        message: 'Log out?',
                        confirmFunction: () async {
                          await auth.signOut();
                          context.go('/login');
                        },
                      );
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: InkWell(
                    onTap: () {
                      _menuKey.currentState!.showButtonMenu();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: borderColor)),
                        color: Colors.grey[50],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(),
                          const SizedBox(width: 20),
                          const Text('MICHAEL LARBI'),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: Row(
              children: [
                SideBar(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
