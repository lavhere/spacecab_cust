import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool showIcon;
  final IconData? icon;
  final Color? iconColor;

  const CustomDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.showIcon = true,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon)
              Icon(
                icon ?? Icons.info_outline,
                size: 48,
                color: iconColor ?? AppTheme.primaryColor,
              ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (cancelText != null)
                  TextButton(
                    onPressed: onCancel ?? () => Navigator.pop(context),
                    child: Text(cancelText!),
                  ),
                if (confirmText != null) ...[
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: onConfirm ?? () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(confirmText!),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
