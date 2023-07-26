import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/utils/colors.dart';
import 'package:touriso_agent/utils/variables.dart';

// ignore: must_be_immutable
class SideBar extends StatelessWidget {
  SideBar({
    super.key,
  });

  final GlobalKey<PopupMenuButtonState> _menuKey =
      GlobalKey<PopupMenuButtonState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 200,
      decoration: BoxDecoration(
        border: Border(right: BorderSide(color: borderColor)),
        color: Colors.grey[50],
      ),
      child: Column(
        children: [
          const SizedBox(height: 40),
          StatefulBuilder(builder: (context, setState) {
            return ListView.builder(
              shrinkWrap: true,
              primary: false,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: pages.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  selectedPage = index;
                  setState(() {});
                  context.go('/${pages[index].toLowerCase()}');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: selectedPage == index
                        ? Colors.grey[300]
                        : Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        icons[index],
                        // color:
                        //     selectedPage == index ? Colors.white : Colors.black,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          pages[index],
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Spacer(),
          PopupMenuButton(
            //TODO: move profile to top right
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: InkWell(
              onTap: () {
                _menuKey.currentState!.showButtonMenu();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black54,
                ),
                child: const Row(
                  children: [
                    Icon(Icons.person, color: Colors.white),
                    SizedBox(width: 5),
                    Text(
                      'Profile',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<String> pages = ['Dashboard', 'Orders', 'History', 'Services'];

List<IconData> icons = [
  Icons.dashboard,
  Icons.list,
  Icons.history,
  Icons.room_service_rounded
];
