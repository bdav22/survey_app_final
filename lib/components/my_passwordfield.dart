import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;

  const PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: widget.controller,
        obscureText: passwordObscured,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade800),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700, width: 2),
            ),
            fillColor: Colors.black54,
            filled: true,
            hintText: widget.hintText,
            hintStyle: TextStyle(color: Colors.grey[600]),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  passwordObscured = !passwordObscured;
                });
              },
              icon: passwordObscured
                  ? Icon(
                      Icons.visibility_off,
                      color: Colors.grey.shade600,
                    )
                  : Icon(
                      Icons.visibility,
                      color: Colors.grey.shade600,
                    ),
            )),
      ),
    );
  }
}