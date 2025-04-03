import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String label;
  final Color bgColor;
  final Color labelColor;
  final VoidCallback onTap;
  const AppButton({
    super.key,
    required this.label,
    required this.bgColor,
    required this.labelColor,
    required this.onTap,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 73,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: widget.bgColor,
        ),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
              color: widget.labelColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
