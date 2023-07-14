import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:touriso_agent/models/tour/site.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';

class EditSite extends StatefulWidget {
  const EditSite({super.key, this.site});
  final Site? site;

  @override
  State<EditSite> createState() => _EditSiteState();
}

class _EditSiteState extends State<EditSite> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  ValueNotifier<GeoPoint?> geoLocationNotifier = ValueNotifier<GeoPoint?>(null);
  TextEditingController descriptionController = TextEditingController();
  ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  setButtonState() {
    if (nameController.text.isEmpty ||
        locationController.text.isEmpty ||
        geoLocationNotifier.value == null ||
        descriptionController.text.isEmpty) {
      buttonEnabledNotifier.value = false;
    } else {
      buttonEnabledNotifier.value = true;
    }
  }

  @override
  void initState() {
    super.initState();

    nameController.addListener(() {
      setButtonState();
    });
    locationController.addListener(() {
      setButtonState();
    });
    geoLocationNotifier.addListener(() {
      setButtonState();
    });
    descriptionController.addListener(() {
      setButtonState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      showBackButton: true,
      title: 'Edit tourist site',
      actions: [
        IconTextButton(
          icon: Icons.delete,
          color: Colors.red,
          onPressed: () {},
        ),
      ],
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
              controller: locationController,
              labelText: 'Location:',
            ),
            const SizedBox(height: 20),
            GeoLocationTextFields(geoLocationNotifier: geoLocationNotifier),
            const SizedBox(height: 20),
            EditDetailsTextFormField(
              controller: descriptionController,
              labelText: 'Description:',
              maxLines: 10,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                const Spacer(),
                StatefulLoadingButton(
                  buttonEnabledNotifier: buttonEnabledNotifier,
                  onPressed: () {},
                  child: Text('${widget.site == null ? 'Add' : 'Update'} site'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    locationController.dispose();
    geoLocationNotifier.dispose();
    descriptionController.dispose();

    super.dispose();
  }
}
