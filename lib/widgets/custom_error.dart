import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomError extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData? icon;
  final Color? iconColor;

  const CustomError({
    Key? key,
    required this.message,
    this.onRetry,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.error_outline,
            size: 64,
            color: iconColor ?? Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
