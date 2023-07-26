import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/models/cduration.dart';
import 'package:touriso_agent/models/site/activity.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/utils/constants.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';

class ActivityForm extends StatefulWidget {
  const ActivityForm({super.key, this.activity, required this.siteId});
  final Activity? activity;
  final String siteId;

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  String? durationUnit;
  TextEditingController priceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  setButtonState() {
    if (nameController.text.isEmpty ||
        durationController.text.isEmpty ||
        double.tryParse(durationController.text) == null ||
        durationUnit == null ||
        priceController.text.isEmpty ||
        double.tryParse(priceController.text) == null ||
        descriptionController.text.isEmpty) {
      buttonEnabledNotifier.value = false;
    } else {
      buttonEnabledNotifier.value = true;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.activity != null) {
      nameController.text = widget.activity!.name;
      durationController.text = widget.activity!.duration.value.toString();
      durationUnit = widget.activity!.duration.unit;
      priceController.text = widget.activity!.price.toString();
      locationController.text = widget.activity!.location ?? '';
      descriptionController.text = widget.activity!.description;
    }

    nameController.addListener(() {
      setButtonState();
    });
    durationController.addListener(() {
      setButtonState();
    });
    priceController.addListener(() {
      setButtonState();
    });
    locationController.addListener(() {
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
            controller: durationController,
            labelText: 'Duration:',
          ),
          DropdownButtonFormField(
            onChanged: (value) {
              durationUnit = value;
            },
            value: durationUnit,
            items: durationUnits
                .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
          EditDetailsTextFormField(
            controller: priceController,
            labelText: 'Price:',
            prefix: Text(ghanaCedi),
          ),
          const SizedBox(height: 20),
          EditDetailsTextFormField(
            controller: locationController,
            labelText: 'Location:',
          ),
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
                    if (widget.activity == null) {
                      id = (await addActivity()).id;
                    } else {
                      await editActivity();
                      id = widget.activity!.id;
                    }

                    Navigator.pop(context);
                    context.push('/services/site/${widget.siteId}/activity/$id');
                  } catch (e) {
                    print(e);
                    showAlertDialog(context);
                  }
                },
                child: Text(
                    '${widget.activity == null ? 'Add' : 'Edit'} activity'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<DocumentReference<Object?>> addActivity() async {
    return await activitiesCollection.add(
      Activity.empty(
        siteId: widget.siteId,
        name: nameController.text.trim(),
        duration:
            CDuration(double.parse(durationController.text), durationUnit!),
        price: double.parse(priceController.text),
        location: locationController.text.trim(),
        description: descriptionController.text.trim(),
        // imageUrls: [],
      ).toFirebase(),
    );
  }

  editActivity() async {
    await activitiesCollection.doc(widget.activity!.id).update(
          Activity(
            id: widget.activity!.id,
            siteId: widget.siteId,
            name: nameController.text,
            duration:
                CDuration(double.parse(durationController.text), durationUnit!),
            price: double.parse(priceController.text),
            location: locationController.text.trim(),
            description: descriptionController.text,
            imageUrls: widget.activity!.imageUrls,
          ).toFirebase(),
        );
  }

  @override
  void dispose() {
    nameController.dispose();
    durationController.dispose();
    priceController.dispose();
    locationController.dispose();
    descriptionController.dispose();

    super.dispose();
  }
}

List<String> durationUnits = ['minutes', 'hours', 'days'];
