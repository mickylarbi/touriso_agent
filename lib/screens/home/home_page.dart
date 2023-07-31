import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/models/company.dart';
import 'package:touriso_agent/screens/home/side_bar.dart';
import 'package:touriso_agent/utils/colors.dart';
import 'package:touriso_agent/utils/constants.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/text_styles.dart';

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
                Hero(
                  tag: kLogoTag,
                  child: Image.asset(
                    'assets/images/TOURISO 2.png',
                    height: 50,
                  ),
                ),
                const Spacer(),
                PopupMenuButton(
                  key: _menuKey,
                  itemBuilder: (context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      value: 'Profile',
                      child: Row(
                        children: [
                          Icon(Icons.person_outline_rounded),
                          SizedBox(width: 20),
                          Text('Profile'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'Log out',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 20),
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
                    if (value == 'Profile') {
                      context.go('/profile');
                    }
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: FutureBuilder(
                    future:
                        companiesCollection.doc(auth.currentUser!.uid).get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Company company = Company.fromFirebase(
                            snapshot.data!.data() as Map<String, dynamic>,
                            snapshot.data!.id);

                        return InkWell(
                          onTap: () {
                            _menuKey.currentState!.showButtonMenu();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border:
                                  Border(left: BorderSide(color: borderColor)),
                              color: Colors.grey[50],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(company.logoUrl),
                                  backgroundColor: Colors.grey[200],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(company.name),
                                    Text(
                                      company.email,
                                      style: bodySmall(context),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        );
                      }

                      return Container();
                    },
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
