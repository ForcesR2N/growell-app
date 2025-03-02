import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? errorText;
  final Function(String) onChanged;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.errorText,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (errorText != null)
          Text(
            errorText!,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w300,
            ),
          ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0x33C4C4C4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.black54,
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w300,
              ),
              prefixIcon: Icon(prefixIcon),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),
        ),
      ],
    );
  }
}
