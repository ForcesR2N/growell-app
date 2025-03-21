import 'package:flutter/material.dart';
import 'package:growell_app/widget_daily/app_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final List<Widget>? actions;
  
  const SectionHeader({
    Key? key,
    required this.title,
    required this.icon,
    this.iconColor,
    this.actions,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppStyles.primaryColor,
              size: 22,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppStyles.subtitleStyle,
            ),
          ],
        ),
        if (actions != null) Row(children: actions!),
      ],
    );
  }
}
