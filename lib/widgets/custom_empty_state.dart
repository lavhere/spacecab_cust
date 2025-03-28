import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomEmptyState extends StatelessWidget {
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? icon;
  final Color? iconColor;

  const CustomEmptyState({
    Key? key,
    required this.message,
    this.actionText,
    this.onAction,
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
            icon ?? Icons.inbox_outlined,
            size: 64,
            color: iconColor ?? Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onAction,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}
