import 'package:flutter/material.dart';
import 'package:mobile/core/widgets/asym_card.dart';

class LabeledTextField extends StatelessWidget {
  const LabeledTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.prefixText,
    this.readOnly = false,
    this.keyboardType,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final String? prefixText;
  final bool readOnly;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -10,
          left: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            color: Theme.of(context).scaffoldBackgroundColor, // Background of the label
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
          ),
        ),
        AsymCard(
          color: Theme.of(context).cardColor,
          borderColor: Theme.of(context).dividerColor,
          borderWidth: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              if (prefixText != null)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    prefixText!,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  readOnly: readOnly,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
