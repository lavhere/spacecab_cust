import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 56.0,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bgColor =
        backgroundColor ??
        (isOutlined ? Colors.transparent : AppTheme.primaryColor);
    final txtColor =
        textColor ?? (isOutlined ? AppTheme.primaryColor : Colors.white);

    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child:
          isOutlined
              ? OutlinedButton(
                onPressed: isLoading ? null : onPressed,
                style: OutlinedButton.styleFrom(
                  foregroundColor: txtColor,
                  side: BorderSide(color: txtColor, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(12),
                  ),
                ),
                child: _buildButtonContent(),
              )
              : ElevatedButton(
                onPressed: isLoading ? null : onPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: bgColor,
                  foregroundColor: txtColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(12),
                  ),
                ),
                child: _buildButtonContent(),
              ),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return const CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      );
    }

    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }
}
