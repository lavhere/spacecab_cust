import 'package:flutter/material.dart';
import '../config/theme.dart';

class LocationSearchBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final VoidCallback? onTap;
  final bool readOnly;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;

  const LocationSearchBox({
    Key? key,
    required this.controller,
    this.hintText = 'Search for a location',
    this.prefixIcon = Icons.search,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppTheme.textSecondaryColor),
          prefixIcon:
              prefixIcon != null
                  ? Icon(prefixIcon, color: AppTheme.textSecondaryColor)
                  : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        style: TextStyle(color: AppTheme.textPrimaryColor),
      ),
    );
  }
}
