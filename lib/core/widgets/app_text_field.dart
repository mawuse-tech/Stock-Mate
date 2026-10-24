import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.numeric = false,
    this.wholeNumber = false,
    this.required = true,
  });

  final String label;
  final TextEditingController controller;
  final bool numeric;
  final bool wholeNumber;
  final bool required;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: wholeNumber
        ? TextInputType.number
        : numeric
        ? const TextInputType.numberWithOptions(decimal: true)
        : TextInputType.text,
    decoration: InputDecoration(labelText: label),
    validator: (value) {
      if (required && (value == null || value.trim().isEmpty)) {
        return 'This field is required';
      }
      if (wholeNumber &&
          value != null &&
          value.isNotEmpty &&
          int.tryParse(value) == null) {
        return 'Enter a whole number';
      }
      if (numeric &&
          value != null &&
          value.isNotEmpty &&
          (double.tryParse(value) == null || double.parse(value) < 0)) {
        return 'Enter a valid amount';
      }
      return null;
    },
  );
}
