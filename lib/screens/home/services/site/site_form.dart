import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/models/site/site.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';

class SiteForm extends StatefulWidget {
  const SiteForm({super.key, this.site});
  final Site? site;

  @override
  State<SiteForm> createState() => _SiteFormState();
}

class _SiteFormState extends State<SiteForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  ValueNotifier<GeoPoint?> geoLocationNotifier = ValueNotifier(null);
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

    if (widget.site != null) {
      nameController.text = widget.site!.name;
      locationController.text = widget.site!.location;
      geoLocationNotifier.value = widget.site!.geoLocation;
      descriptionController.text = widget.site!.description;
    }

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
    return SingleChildScrollView(
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
                onPressed: () async {
                  try {
                    String id = '';
                    if (widget.site == null) {
                      id = (await addSite()).id;
                    } else {
                      await editSite();
                      id = widget.site!.id;
                    }

                    Navigator.pop(context, true);
                    // ignore: use_build_context_synchronously
                    context.push('/services/site/$id');
                  } catch (e) {
                    print(e);
                    showAlertDialog(context);
                  }
                },
                child: Text('${widget.site == null ? 'Add' : 'Update'} site'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<DocumentReference<Object?>> addSite() async {
    return await sitesCollection.add(
      Site.empty(
        companyId: uid,
        name: nameController.text.trim(),
        location: locationController.text.trim(),
        geoLocation: geoLocationNotifier.value!,
        description: descriptionController.text.trim(),
        // imageUrls: [],
      ).toFirebase(),
    );
  }

  editSite() async {
    await sitesCollection.doc(widget.site!.id).update(
          Site(
            id: widget.site!.id,
            companyId: uid,
            name: nameController.text,
            location: locationController.text,
            geoLocation: geoLocationNotifier.value!,
            description: descriptionController.text,
            imageUrls: widget.site!.imageUrls,
          ).toFirebase(),
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
