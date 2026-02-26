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
  final String? hintText;
  final Widget? prefixIcon;

  const CustomTextField({
    Key? key,
    required this.label,
    required this.controller,
    this.isRequired = true,
    this.isNumeric = false,
    this.maxLength,
    this.obscureText = false,
    this.customValidator,
    this.hintText,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          maxLength: maxLength,
          obscureText: obscureText,
          validator: (value) {
            final l10n = AppLocalizations.of(context)!;
            if (isRequired && (value == null || value.isEmpty)) {
              return l10n.fieldRequired;
            }
            // Adjusted to be more generic, specific message can be passed via customValidator
            if (maxLength != null && value != null && value.length != maxLength) {
              return l10n.mustBeNdigits(maxLength!);
            }
            if (customValidator != null) {
              return customValidator!(value);
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            counterText: "", // Hides the maxLength counter
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
