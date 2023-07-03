import 'package:flutter/material.dart';
import 'package:touriso_agent/utils/text_styles.dart';
// import 'package:touriso_agent/models/hotels/room.dart';

class RoomsGrid extends StatelessWidget {
  const RoomsGrid({super.key});
  // final List<Room> rooms = const [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: grid(context),
    );
  }

  List<Widget> grid(context) {
    int rowWidth = 4;
    int filledColumns = (rooms.length / rowWidth).floor();
    int remainder = rooms.length % rowWidth;
    bool hasRemainder = remainder != 0;

    return [
      if (filledColumns != 0)
        ...List.generate(
          filledColumns,
          (index) {
            return Row(
              children: List.generate(rowWidth, (rowIndex) {
                // int roomIndex =(rowWidth * index) + rowIndex;

                return Expanded(
                  child: Container(
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
                                        text: '\$400',
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
                              ((rowWidth * index) + rowIndex).toString(),
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            bookedIndicator(context)
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
            );
          },
        ),
      if (hasRemainder)
        Row(
          children: [
            ...List.generate(remainder, (rowIndex) {
              // int roomIndex = (rowWidth * filledColumns) + rowIndex;

              return Expanded(
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(12),
                  color: Colors.green,
                  child: Row(
                    children: [
                      Text(
                        ((rowWidth * filledColumns) + rowIndex).toString(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              );
            }),
            ...List.generate(rowWidth - (remainder), (index) => const Spacer())
          ],
        )
    ];
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

List rooms = List.generate(229, (index) => 1);

String lipsum =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
