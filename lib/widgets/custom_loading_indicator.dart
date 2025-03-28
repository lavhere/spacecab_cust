import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomLoadingIndicator extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;
  final double strokeWidth;

  const CustomLoadingIndicator({
    Key? key,
    this.message,
    this.color,
    this.size = 40,
    this.strokeWidth = 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? AppTheme.primaryColor,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }
}
