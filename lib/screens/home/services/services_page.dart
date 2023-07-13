import 'package:flutter/material.dart';
import 'package:touriso_agent/screens/home/services/add_service_button.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      sectioned: true,
      title: 'Services',
      actions: const [AddServiceButton()],
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
        children: [
          Section(
            titleText: 'Sites',
            child: Container(),
          ),
          const SizedBox(height: 40),
          Section(
            titleText: 'Hotels',
            child: Container(),
          ),
          const SizedBox(height: 40),
          Section(
            titleText: 'Apartments',
            child: Container(),
          ),
          const SizedBox(height: 40),
          Section(
            titleText: 'Flight',
            child: Container(),
          ),
          const SizedBox(height: 40),
          Section(
            titleText: 'Bus',
            child: Container(),
          ),
        ],
      ),
    );
  }
}
