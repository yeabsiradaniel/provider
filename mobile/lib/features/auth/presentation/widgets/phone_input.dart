import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class PhoneInput extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  const PhoneInput({Key? key, required this.controller, required this.labelText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      maxLength: 9, // Enforce 9 digits
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.fieldRequired;
        }
        if (value.length != 9) {
          return AppLocalizations.of(context)!.phoneMustBe9Digits;
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: labelText,
        prefixText: '+251 ',
        prefixStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1E293B),
        ),
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
