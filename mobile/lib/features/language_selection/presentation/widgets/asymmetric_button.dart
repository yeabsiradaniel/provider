import 'package:flutter/material.dart';

class AsymmetricButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AsymmetricButton({
    Key? key,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: onPressed != null ? const Color(0xFF0056B3) : const Color(0xFFE2E8F0),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(24),
        topRight: Radius.circular(8),
        bottomLeft: Radius.circular(8),
        bottomRight: Radius.circular(24),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(8),
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(24),
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: onPressed != null ? Colors.white : const Color(0xFF94A3B8),
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
