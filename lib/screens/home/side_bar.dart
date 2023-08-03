import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/utils/colors.dart';
import 'package:touriso_agent/utils/variables.dart';

// ignore: must_be_immutable
class SideBar extends StatelessWidget {
  const SideBar({super.key});

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
        ],
      ),
    );
  }
}

List<String> pages = ['Bookings', 'Services'];

List<IconData> icons = [
  // Icons.dashboard,
  Icons.list,
  Icons.room_service_rounded
];
