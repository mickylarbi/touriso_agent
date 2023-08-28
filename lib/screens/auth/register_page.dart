import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touriso_agent/models/company.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/screens/shared/custom_text_span.dart';
import 'package:touriso_agent/utils/constants.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/dimensions.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController companyMottoController = TextEditingController();
  final TextEditingController companyEmailController = TextEditingController();
  final ValueNotifier<XFile?> companyLogoNotifier = ValueNotifier(null);
  final TextEditingController _passwordController = TextEditingController();

  final ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  setButtonState() {
    if (companyNameController.text.trim().isEmpty ||
        companyMottoController.text.trim().isEmpty ||
        companyEmailController.text.trim().isEmpty ||
        !companyEmailController.text.trim().contains(RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")) ||
        companyLogoNotifier.value == null ||
        _passwordController.text.trim().isEmpty ||
        _passwordController.text.trim().length < 6) {
      buttonEnabledNotifier.value = false;
    } else {
      buttonEnabledNotifier.value = true;
    }
  }

  @override
  void initState() {
    super.initState();

    companyNameController.addListener(() {
      setButtonState();
    });
    companyMottoController.addListener(() {
      setButtonState();
    });
    companyEmailController.addListener(() {
      setButtonState();
    });
    companyLogoNotifier.addListener(() {
      setButtonState();
    });
    _passwordController.addListener(() {
      setButtonState();
    });
  }

  @override
  Widget build(BuildContext context) {
    //TODO: focus node things
    return Center(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 200),
        children: [
          Hero(
            tag: kLogoTag,
            child: Image.asset(
              'assets/images/TOURISO 2.png',
              width: (kScreenWidth(context) / 2) * 0.8,
            ),
          ),
          const SizedBox(height: 40),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Register',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: companyNameController,
            hintText: 'Company name',
            prefixIcon: const Icon(Icons.person_outline_rounded),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: companyMottoController,
            hintText: 'Company motto',
            prefixIcon: const Icon(Icons.short_text_rounded),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: companyEmailController,
            hintText: 'Company email',
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          const SizedBox(height: 20),

          //TODO: IMAGE PICKER THINGS
          ValueListenableBuilder<XFile?>(
            valueListenable: companyLogoNotifier,
            builder: (BuildContext context, XFile? value, Widget? child) {
              return Column(
                children: [
                  if (value != null) Image.network(value.path, width: 300),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();

                      picker
                          .pickImage(source: ImageSource.gallery)
                          .then((value) {
                        companyLogoNotifier.value = value;
                      }).onError((error, stackTrace) {
                        showAlertDialog(context);
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('${value == null ? 'Choose' : 'Change'} image'),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          PasswordTextFormField(controller: _passwordController),
          const SizedBox(height: 40),
          StatefulLoadingButton(
            buttonEnabledNotifier: buttonEnabledNotifier,
            onPressed: () async {
              try {
                await register();

                context.go('/bookings');
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  showAlertDialog(
                    context,
                    message: 'The password provided is too weak.',
                  );
                } else if (e.code == 'email-already-in-use') {
                  showAlertDialog(
                    context,
                    message: 'An account already exists for that email.',
                  );
                }
              } catch (e) {
                print(e);
                showAlertDialog(context);
              }
            },
            child: const Text('REGISTER'),
          ),
          const SizedBox(height: 30),
          CustomTextSpan(
            firstText: 'Already registered?',
            secondText: 'Login here',
            onPressed: () {
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Future register() async {
    await auth.createUserWithEmailAndPassword(
        email: companyEmailController.text.trim(),
        password: _passwordController.text);

    await logosRef(uid).putData(await companyLogoNotifier.value!.readAsBytes());

    await companiesCollection.doc(uid).set(
          Company(
            name: companyNameController.text.trim(),
            motto: companyMottoController.text.trim(),
            email: companyEmailController.text.trim(),
            logoUrl: await logosRef(uid).getDownloadURL(),
          ).toFirebase(),
        );
  }

  @override
  void dispose() {
    companyNameController.dispose();
    companyMottoController.dispose();
    companyEmailController.dispose();
    companyLogoNotifier.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
