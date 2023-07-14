import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/screens/shared/custom_text_form_field.dart';
import 'package:touriso_agent/screens/shared/custom_text_span.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key, this.authType = AuthType.login});
  final AuthType authType;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Sign ${widget.authType == AuthType.signUp ? 'up' : 'in'}',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          if (widget.authType == AuthType.signUp) const SizedBox(height: 20),
          if (widget.authType == AuthType.signUp)
            CustomTextFormField(
              controller: _fullNameController,
              hintText: 'Full name',
              prefixIcon: const Icon(Icons.person_outline_rounded),
            ),
          const SizedBox(height: 20),
          EditDetailsTextFormField(
            controller: _emailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_outlined),
          ),
          const SizedBox(height: 20),
          PasswordTextFormField(controller: _passwordController),
          if (widget.authType == AuthType.login) const SizedBox(height: 10),
          if (widget.authType == AuthType.login)
            TextButton(
              onPressed: () {},
              child: Text(
                'Forgot password?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  // fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          const SizedBox(height: 40),
          LoadingButton(
            onPressed: () {
              context.go('/');
              // if (_emailController.text.trim().isEmpty ||
              //     _passwordController.text.isEmpty ||
              //     (widget.authType == AuthType.signUp &&
              //         _confirmPasswordController.text.isEmpty)) {
              //   showAlertDialog(context,
              //       message: 'One or more fields are empty');
              // } else if (!_emailController.text.trim().contains(RegExp(
              //     r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))) {
              //   showAlertDialog(context,
              //       message: 'Email address is invalid');
              // } else if (widget.authType == AuthType.signUp &&
              //     (_passwordController.text !=
              //         _confirmPasswordController.text)) {
              //   showAlertDialog(context,
              //       message: 'Passwords do not match');
              // } else if (_passwordController.text.length < 6) {
              //   showAlertDialog(context,
              //       message:
              //           'Password should not be less than 6 characters');
              // } else {
              //   if (widget.authType == AuthType.login) {
              //     _auth.signIn(
              //       context,
              //       email: _emailController.text.trim(),
              //       password: _passwordController.text,
              //     );
              //   } else {
              //     _auth.signUp(context,
              //         email: _emailController.text.trim(),
              //         password: _passwordController.text);
              //   }
              // }
            },
            child:
                Text(widget.authType == AuthType.login ? 'SIGN UP' : 'SIGN IN'),
          ),
          const SizedBox(height: 30),
          CustomTextSpan(
            firstText: widget.authType == AuthType.login
                ? "Don't have an account?"
                : 'Already have an account?',
            secondText:
                widget.authType == AuthType.login ? 'Sign up' : 'Sign in',
            onPressed: () {
              context
                  .go(widget.authType == AuthType.login ? '/signup' : '/login');
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
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

enum AuthType { login, signUp }
