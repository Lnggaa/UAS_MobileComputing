import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final int maxLines;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.maxLines = 1,
    this.validator,
    this.prefixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.labelMedium),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          validator: validator,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyLarge,
          decoration: InputDecoration(hintText: hint, prefixIcon: prefixIcon),
        ),
      ],
    );
  }
}
