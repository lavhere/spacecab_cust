import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomBottomSheet extends StatelessWidget {
  final Widget child;
  final String? title;
  final Widget? trailing;
  final bool showDragHandle;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const CustomBottomSheet({
    Key? key,
    required this.child,
    this.title,
    this.trailing,
    this.showDragHandle = true,
    this.height,
    this.padding,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDragHandle)
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (title != null || trailing != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  if (trailing != null) trailing!,
                ],
              ),
            ),
          Flexible(child: child),
        ],
      ),
    );
  }
}
