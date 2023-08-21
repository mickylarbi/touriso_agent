import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touriso_agent/models/company.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/screens/shared/empty_widget.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController companyMottoController = TextEditingController();
  TextEditingController companyEmailController = TextEditingController();
  final ValueNotifier<XFile?> companyLogoNotifier = ValueNotifier(null);

  final ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    // TODO: move this page to root route
    return PageLayout(
      title: 'Profile',
      actions: const [
        // TextButton(
        //   onPressed: () {},
        //   child: const Text('Change password'),
        // )
      ],
      body: FutureBuilder(
        future: companiesCollection.doc(auth.currentUser!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: CustomErrorWidget());
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Company company = Company.fromFirebase(
                snapshot.data!.data() as Map<String, dynamic>,
                snapshot.data!.id);

            companyNameController.text = company.name;
            companyMottoController.text = company.motto;
            companyEmailController.text = company.email;

            return ListView(
              padding: const EdgeInsets.only(left: 36, right: 500, top: 40),
              children: [
                ProfileDetailListTile(
                  labelText: 'Name',
                  currentValue: company.name,
                ),
                const Divider(height: 20),
                ProfileDetailListTile(
                  currentValue: company.motto,
                  labelText: 'Motto',
                ),
                const Divider(height: 20),
                ProfileDetailListTile(
                  currentValue: company.email,
                  labelText: 'Email',
                ),
              ],
            );
          }

          return const Center(child: CircularProgressIndicator.adaptive());
        },
      ),
    );
  }

  @override
  void dispose() {
    companyNameController.dispose();
    companyMottoController.dispose();
    companyEmailController.dispose();
    companyLogoNotifier.dispose();

    super.dispose();
  }
}

class ProfileDetailListTile extends StatefulWidget {
  const ProfileDetailListTile({
    super.key,
    required this.currentValue,
    required this.labelText,
  });

  final String currentValue;
  final String labelText;

  @override
  State<ProfileDetailListTile> createState() => _ProfileDetailListTileState();
}

class _ProfileDetailListTileState extends State<ProfileDetailListTile> {
  final TextEditingController controller = TextEditingController();
  ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  setButtonState() {
    if (controller.text.isEmpty || controller.text == widget.currentValue) {
      buttonEnabledNotifier.value = false;
    } else {
      buttonEnabledNotifier.value = true;
    }
  }

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      setButtonState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.labelText}:', style: bodySmall(context)),
            Text(widget.currentValue),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () async {
            controller.text = widget.currentValue;

            await showFormDialog(
              context,
              ListView(
                shrinkWrap: true,
                children: [
                  CustomTextFormField(
                    controller: controller,
                    hintText: widget.labelText,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Spacer(),
                      StatefulLoadingButton(
                        buttonEnabledNotifier: buttonEnabledNotifier,
                        onPressed: () async {
                          try {
                            await companiesCollection
                                .doc(auth.currentUser!.uid)
                                .update({
                              widget.labelText.toLowerCase():
                                  controller.text.trim()
                            });

                            Navigator.of(context, rootNavigator: true).pop();
                            context.go('/profile');
                            print('here');
                          } catch (e) {
                            print(e);
                            showAlertDialog(context);
                          }
                        },
                        child: Text('Change ${widget.labelText.toLowerCase()}'),
                      ),
                    ],
                  ),
                  if (widget.labelText == 'Email') const SizedBox(height: 20),
                  if (widget.labelText == 'Email')
                    Text('Email for login will remain the same',
                        style: bodySmall(context)),
                ],
              ),
            );
          },
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    buttonEnabledNotifier.dispose();

    super.dispose();
  }
}
