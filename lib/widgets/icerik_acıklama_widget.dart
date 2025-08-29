import 'package:flutter/material.dart';

class CustomInputWidget extends StatelessWidget {
  final TextEditingController? controller;

  const CustomInputWidget({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: 'İçerik (*Max 250 Karakter)',
          labelStyle: const TextStyle(color: Colors.deepPurple),
          filled: true,
          fillColor: Colors.deepPurple[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        maxLength: 250,
      ),
    );
  }
}
