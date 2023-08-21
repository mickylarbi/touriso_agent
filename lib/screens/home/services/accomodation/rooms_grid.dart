import 'package:flutter/material.dart';
import 'package:touriso_agent/models/hotels/room.dart';
import 'package:touriso_agent/screens/shared/custom_grid.dart';
import 'package:touriso_agent/utils/text_styles.dart';
// import 'package:touriso_agent/models/hotels/room.dart';

class RoomsGrid extends StatelessWidget {
  const RoomsGrid({super.key});
  // final List<Room> rooms = const [];

  @override
  Widget build(BuildContext context) {
    return CustomGrid(
      rowWidth: 4,
      children: List.generate(
        23,
        (index) => RoomCard(
          room: Room(
              description: lipsum,
              id: '',
              imageUrls: const [],
              number: '01',
              price: 145),
        ),
      ),
    );
  }
}

List rooms = List.generate(229, (index) => 1);

String lipsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

class RoomCard extends StatelessWidget {
  const RoomCard({super.key, required this.room});

  final Room room;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lipsum,
                  maxLines: 3,
                  style: bodySmall(context),
                ),
                const SizedBox(height: 5),
                Text.rich(
                  TextSpan(
                    text: 'Price:',
                    style: bodySmall(context),
                    children: [
                      TextSpan(
                          text: room.price.toString(),
                          style: bodyLarge(context)),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Text(
                room.number,
                style: headlineSmall(context),
              ),
              bookedIndicator(context)
            ],
          ),
        ],
      ),
    );
  }

  Container bookedIndicator(context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.done,
            size: 12,
            color: Colors.white,
          ),
          Text(
            'Booked',
            style: labelSmall(context).copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
