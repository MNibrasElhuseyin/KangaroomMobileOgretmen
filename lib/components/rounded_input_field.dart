import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final TextEditingController controller;
  final bool isEmail;
  final bool isPassword;
  final String hintText;
  final IconData icon;
  final bool isPasswordVisible;
  final VoidCallback? togglePasswordVisibility;
  final ValueChanged<String>? onChange;

  const RoundedInputField({
    super.key,
    required this.controller,
    required this.isEmail,
    required this.isPassword,
    required this.hintText,
    required this.icon,
    this.isPasswordVisible = false,
    this.togglePasswordVisibility,
    this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        obscureText: isPassword && !isPasswordVisible,
        keyboardType: TextInputType.text, // Türkçe karakter desteği için
        textCapitalization: TextCapitalization.none,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: togglePasswordVisibility,
          )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        onChanged: onChange,
      ),
    );
  }
}
