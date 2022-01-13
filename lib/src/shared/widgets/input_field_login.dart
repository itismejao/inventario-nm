import 'package:flutter/material.dart';

class InputFieldLogin extends StatelessWidget {
  final IconData icon;
  final String hint;
  final bool obscure;

  const InputFieldLogin({
    required this.icon,
    required this.hint,
    required this.obscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          icon: Icon(
            icon,
            color: const Color(0xFF040491),
          ),
          hintText: hint,
          hintStyle: const TextStyle(
            color: const Color(0xFF040491),
            fontWeight: FontWeight.bold,
          ),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
            color: Color(0xFFD3D3FF),
          )),
          contentPadding:
              const EdgeInsets.only(left: 5, right: 30, bottom: 20, top: 20)),
      style: const TextStyle(color: Color(0xFF040491)),
      obscureText: obscure,
    );
  }
}
