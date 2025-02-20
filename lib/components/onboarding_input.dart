import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OnboardingInput extends StatelessWidget {
  final String hintText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final String? errorText;
  final Function(String) onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const OnboardingInput({
    Key? key,
    required this.hintText,
    this.initialValue,
    this.keyboardType,
    this.errorText,
    required this.onChanged,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: ShapeDecoration(
        color: const Color(0xFFEEF6ED),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: TextField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: 'Signika',
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.black.withOpacity(0.45),
            fontSize: 16,
            fontFamily: 'Signika',
          ),
          border: InputBorder.none,
          errorText: errorText,
        ),
      ),
    );
  }
} 