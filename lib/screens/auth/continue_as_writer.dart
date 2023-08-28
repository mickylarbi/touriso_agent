import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/screens/shared/custom_text_span.dart';
import 'package:touriso_agent/utils/constants.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/dimensions.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';

class ContinueAsWriter1 extends StatefulWidget {
  const ContinueAsWriter1({super.key});

  @override
  State<ContinueAsWriter1> createState() => _ContinueAsWriter1State();
}

class _ContinueAsWriter1State extends State<ContinueAsWriter1> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  setButtonState() {
    if (_emailController.text.isEmpty ||
        !_emailController.text.trim().contains(RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")) ||
        _passwordController.text.isEmpty ||
        _passwordController.text.length < 6) {
      buttonEnabledNotifier.value = false;
    } else {
      buttonEnabledNotifier.value = true;
    }
  }

  @override
  void initState() {
    super.initState();

    _emailController.addListener(() {
      setButtonState();
    });
    _passwordController.addListener(() {
      setButtonState();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              'Continue as writer',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: _emailController,
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          const SizedBox(height: 20),
          PasswordTextFormField(controller: _passwordController),
          const SizedBox(height: 40),
          StatefulLoadingButton(
            buttonEnabledNotifier: buttonEnabledNotifier,
            onPressed: () async {
              try {
                await auth.signInWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text);
                if ((await writersCollection
                        .where('email', isEqualTo: _emailController.text.trim())
                        .get())
                    .docs
                    .isEmpty) {
                  context.go('/writer_login_details');
                } else {
                  context.go('/blog_dash');
                }
              } on FirebaseAuthException catch (e) {
                print(e.code);
                if (e.code == 'user-not-found') {
                  auth
                      .createUserWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text)
                      .then((value) {
                    context.go('/writer_login_details');
                  }).onError((error, stackTrace) {
                    showAlertDialog(context);
                  });
                } else if (e.code == 'wrong-password') {
                  showAlertDialog(
                    context,
                    message: 'Wrong password provided for that user.',
                  );
                } else {
                  showAlertDialog(context);
                }
              } catch (e) {
                showAlertDialog(context);
              }
            },
            child: const Text('LOGIN'),
          ),
          const SizedBox(height: 30),
          CustomTextSpan(
            firstText: '',
            secondText: 'Sign up as an agent',
            onPressed: () {
              context.go('/register');
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}

class ContinueAsWriter2 extends StatefulWidget {
  const ContinueAsWriter2({super.key});

  @override
  State<ContinueAsWriter2> createState() => _ContinueAsWriter2State();
}

class _ContinueAsWriter2State extends State<ContinueAsWriter2> {
  final TextEditingController nameController = TextEditingController();
  final ValueNotifier<XFile?> pictureNotifier = ValueNotifier(null);
  final ValueNotifier<bool> buttonEnabledNotifier = ValueNotifier(false);

  setButtonState() {
    if (nameController.text.trim().isEmpty) {
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
  }

  @override
  Widget build(BuildContext context) {
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
              'Writer details',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          CustomTextFormField(controller: nameController, hintText: 'Name'),
          const SizedBox(height: 20),
          ValueListenableBuilder(
            valueListenable: pictureNotifier,
            builder: (BuildContext context, value, Widget? child) {
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
                        pictureNotifier.value = value;
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
          const SizedBox(height: 40),
          StatefulLoadingButton(
            buttonEnabledNotifier: buttonEnabledNotifier,
            onPressed: () async {
              try {
                if (pictureNotifier.value != null) {
                  await writerPictureRef
                      .putData(await pictureNotifier.value!.readAsBytes());
                }

                writersCollection.doc(uid).set({
                  'name': nameController.text.trim(),
                  'email': auth.currentUser!.email,
                  if (pictureNotifier.value != null)
                    'pictureUrl': await writerPictureRef.getDownloadURL(),
                });

                context.go('/blog_dash');
              } catch (e) {
                print(e);
                showAlertDialog(context);
              }
            },
            child: const Text('REGISTER'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    pictureNotifier.dispose();

    super.dispose();
  }
}
