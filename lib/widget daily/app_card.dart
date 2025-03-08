import 'package:flutter/material.dart';
import 'package:growell_app/widget%20daily/app_styles.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? color;
  final BoxDecoration? decoration;
  
  const AppCard({
    Key? key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.width,
    this.height,
    this.color,
    this.decoration,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: padding,
      decoration: decoration ?? AppStyles.cardDecoration.copyWith(
        color: color ?? Colors.white,
      ),
      child: child,
    );
  }
}