import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool isObscureText;
  final String? Function(String?)? validator; // Optional validator function
  final ValueChanged<String>? onChanged; // Optional onChanged callback

  const AuthField({
    Key? key,
    required this.hintText,
    required this.controller,
    this.isObscureText = false,
    this.validator,
    this.onChanged, // Add onChanged callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscureText,
      controller: controller,
      decoration: InputDecoration(hintText: hintText),
      validator: validator, // Use the provided validator
      onChanged: onChanged, // Pass the onChanged callback
    );
  }
}
