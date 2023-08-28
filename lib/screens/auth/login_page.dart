import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/screens/shared/custom_text_span.dart';
import 'package:touriso_agent/utils/constants.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/dimensions.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              'Login',
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
                if ((await clientsCollection
                        .where('email', isEqualTo: _emailController.text.trim())
                        .get())
                    .docs
                    .isNotEmpty) {
                  showAlertDialog(
                    context,
                    message: 'Email already exists for a client',
                  );
                } else {
                  await auth.signInWithEmailAndPassword(
                    email: _emailController.text.trim(),
                    password: _passwordController.text,
                  );

                  // ignore: use_build_context_synchronously
                  context.go('/bookings');
                }
              } on FirebaseAuthException catch (e) {
                print(e.code);
                if (e.code == 'user-not-found') {
                  showAlertDialog(
                    context,
                    message: 'No user found for that email.',
                  );
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
            firstText: 'Not signed up?',
            secondText: 'Register here',
            onPressed: () {
              context.go('/register');
            },
          ),
          const SizedBox(height: 30),
          CustomTextSpan(
            firstText: '',
            secondText: 'Continue as writer',
            onPressed: () {
              context.go('/writer_login');
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
