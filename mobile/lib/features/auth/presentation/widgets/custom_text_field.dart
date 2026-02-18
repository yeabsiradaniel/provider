import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final bool isNumeric;
  final int? maxLength;
  final TextEditingController controller;
  final bool obscureText;
  final FormFieldValidator<String>? customValidator;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.isRequired = true,
    this.isNumeric = false,
    this.maxLength,
    this.obscureText = false,
    this.customValidator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      maxLength: maxLength,
      obscureText: obscureText,
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return AppLocalizations.of(context)!.fieldRequired;
        }
        if (maxLength != null && value!.length != maxLength) {
          return AppLocalizations.of(context)!.pinMustBe6Digits;
        }
        if (customValidator != null) {
          return customValidator!(value);
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE2E8F0),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFE2E8F0),
            width: 2,
          ),
        ),
      ),
    );
  }
}
