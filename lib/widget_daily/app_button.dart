import 'package:flutter/material.dart';
import 'package:growell_app/widget_daily/app_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final bool isLoading;
  final double? width;
  final double height;
  final Color? color;
  
  const AppButton({
    Key? key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isOutlined = false,
    this.isLoading = false,
    this.width,
    this.height = 48,
    this.color,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final btnColor = color ?? AppStyles.primaryColor;
    
    if (isOutlined) {
      return SizedBox(
        width: width,
        height: height,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: btnColor),
            shape: RoundedRectangleBorder(
              borderRadius: AppStyles.defaultRadius,
            ),
          ),
          child: _buildButtonContent(btnColor),
        ),
      );
    }
    
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: AppStyles.defaultRadius,
          ),
        ),
        child: _buildButtonContent(isOutlined ? btnColor : Colors.white),
      ),
    );
  }
  
  Widget _buildButtonContent(Color textColor) {
    if (isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }
    
    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontFamily: 'Signika',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }
    
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontSize: 16,
        fontFamily: 'Signika',
        fontWeight: FontWeight.w600,
      ),
    );
  }
}