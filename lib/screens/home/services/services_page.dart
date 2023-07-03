import 'package:flutter/material.dart';
import 'package:touriso_agent/screens/home/services/add_service_button.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      title: 'Services',
      actions: const [AddServiceButton()],
      body: ListView(
        children: [],
      ),
    );
  }
}
