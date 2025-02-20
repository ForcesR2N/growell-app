import 'package:flutter/material.dart';

class OnboardingProgress extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const OnboardingProgress({
    Key? key,
    required this.currentPage,
    required this.totalPages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => Container(
          width: index == currentPage ? 20 : 12,
          height: index == currentPage ? 10 : 8,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: ShapeDecoration(
            color: index == currentPage 
                ? const Color(0xFFFF8473) 
                : const Color(0xFFFFC0B7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
} 