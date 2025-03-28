import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomListTile extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final bool isSelected;

  const CustomListTile({
    Key? key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.contentPadding,
    this.backgroundColor,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: leading,
          title: title,
          subtitle: subtitle,
          trailing: trailing,
          onTap: onTap,
          contentPadding:
              contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          selected: isSelected,
          selectedColor: AppTheme.primaryColor,
          selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
          tileColor: backgroundColor,
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}
