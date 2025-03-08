import 'package:flutter/material.dart';
import 'package:growell_app/widget%20daily/app_styles.dart';

class NutrientProgressBar extends StatelessWidget {
  final String label;
  final String value;
  final double percentage;
  final Color color;
  final IconData icon;
  
  const NutrientProgressBar({
    Key? key,
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
    required this.icon,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppStyles.bodyStyle.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              value,
              style: AppStyles.bodyStyle.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Container(
              height: 8,
              width: (MediaQuery.of(context).size.width - 48) * (percentage / 100 > 1 ? 1 : percentage / 100),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}