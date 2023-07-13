import 'package:flutter/material.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';
import 'package:touriso_agent/utils/constants.dart';

class EditActivityPage extends StatefulWidget {
  const EditActivityPage({super.key});

  @override
  State<EditActivityPage> createState() => _EditActivityPageState();
}

class _EditActivityPageState extends State<EditActivityPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  String? durationUnit;
  TextEditingController priceController = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController description = TextEditingController();
  List<String> imageUrls = [];

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      showBackButton: true,
      title: 'Edit activity',
      actions: [],
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 36, right: 500, top: 40),
        child: Column(
          children: [
            EditDetailsTextFormField(
              controller: nameController,
              labelText: 'Name:',
            ),
            const SizedBox(height: 20),
            EditDetailsTextFormField(
              controller: durationController,
              labelText: 'Duration',
              suffix: DropdownButtonFormField(
                onChanged: (value) {},
                value: durationUnit,
                items: durationUnits
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 20),
            EditDetailsTextFormField(
              controller: priceController,
              labelText: 'Price',
              prefix: Text(ghanaCedi),
            )
          ],
        ),
      ),
    );
  }

  List<String> durationUnits = ['minutes', 'hours', 'days'];
}
