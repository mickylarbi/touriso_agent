import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';

class AddServiceButton extends StatelessWidget {
  const AddServiceButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MenuTextButton(
      title: 'Add service',
      items: List.generate(
        services.length,
        (index) => PopupMenuItem(
          value: services[index],
          child: Row(
            children: [
              Icon(serviceIcons[index]),
              const SizedBox(width: 5),
              Text(services[index]),
            ],
          ),
        ),
      ),
      onSelected: (value) {
        String path = '/services';

        if (value == 'Hotel') {
          path += '/edit_hotel/:0';
        }

        if (value == 'Tourist Site') {
          path += '/edit_site/:0';
        }
        // else if (value == 'Apartment') {
        //   path = '/add_apartment';
        // } else if (value == 'Flight' || value == 'Bus') {
        //   path = '/add_transport';
        // } else {
        //   path = '/add_site';
        // }

        context.go(path);
      },
    );
  }
}

List<String> services = ['Hotel', 'Apartment', 'Flight', 'Bus', 'Tourist Site'];
List<IconData> serviceIcons = [
  Icons.hotel_rounded,
  Icons.apartment_rounded,
  Icons.flight_rounded,
  Icons.directions_bus_rounded,
  Icons.tour_rounded,
];
