import 'package:emplify/utils/app_theme.dart';
import 'package:flutter/material.dart';

class AppFormField extends StatefulWidget {
  final TextEditingController controller;
  final bool isTypeable;
  final String hintLabel;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final Function() callback;
  final TextInputType? inputType;
  const AppFormField({
    super.key,
    required this.controller,
    required this.isTypeable,
    required this.hintLabel,
    required this.prefixIcon,
    required this.callback,
    this.suffixIcon,
    this.inputType,
  });

  @override
  State<AppFormField> createState() => _AppFormFieldState();
}

class _AppFormFieldState extends State<AppFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.inputType,
      readOnly: !widget.isTypeable, // Only make the dropdown field readOnly
      onTap: widget.isTypeable ? null : widget.callback,
      cursorColor: AppTheme.textColor,
      decoration: InputDecoration(
        hintText: widget.hintLabel,
        hintStyle: const TextStyle(color: AppTheme.hintColor),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(
            color: AppTheme.borderColor,
            width: 1,
          )
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: AppTheme.borderColor,
              width: 1,
            )
        ),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: const BorderSide(
              color: AppTheme.borderColor,
              width: 1,
            )
        ),
      ),
    );
  }
}
