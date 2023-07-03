import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon,
    this.keyboardType,
    this.maxLines,
    this.minLines,
    this.textAlign,
  });

  final TextEditingController controller;
  final String hintText;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: bodyMedium(context),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[100]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        prefixIcon: prefixIcon,
      ),
      maxLines: maxLines,
      minLines: minLines,
      textAlign: textAlign ?? TextAlign.start,
    );
  }
}

class PasswordTextFormField extends StatefulWidget {
  final String? hintText;
  final TextEditingController controller;
  const PasswordTextFormField({
    Key? key,
    this.hintText = 'Password',
    required this.controller,
  }) : super(key: key);

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscureText,
      builder: (context, value, child) {
        return TextFormField(
          controller: widget.controller,
          obscureText: value,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            prefixIcon: const Icon(Icons.lock_outline_rounded),
            suffixIcon: IconButton(
              icon: Icon(value ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                obscureText.value = !obscureText.value;
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    obscureText.dispose();
    super.dispose();
  }
}

class EditDetailsTextFormField extends StatelessWidget {
  const EditDetailsTextFormField(
      {super.key,
      required this.controller,
      required this.labelText,
      this.maxLines,
      this.minLines});
  final TextEditingController controller;
  final String labelText;
  final int? maxLines;
  final int? minLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText, style: labelSmall(context)),
        CustomTextFormField(
          controller: controller,
          hintText: '',
          maxLines: maxLines,
          minLines: minLines,
        ),
      ],
    );
  }
}

class GeoLocationTextFields extends StatefulWidget {
  const GeoLocationTextFields({super.key, required this.geoLocationNotifier});
  final ValueNotifier<GeoPoint?> geoLocationNotifier;

  @override
  State<GeoLocationTextFields> createState() => _GeolocationTextFieldsState();
}

class _GeolocationTextFieldsState extends State<GeoLocationTextFields> {
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Geolocation', style: labelSmall(context)),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: latitudeController,
                hintText: 'Latitude',
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: CustomTextFormField(
                controller: longitudeController,
                hintText: 'Longitude',
                textAlign: TextAlign.right,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
