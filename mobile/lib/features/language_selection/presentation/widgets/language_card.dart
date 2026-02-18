import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  final String language;
  final String status;
  final bool isSelected;
  final VoidCallback onTap;

  const LanguageCard({
    Key? key,
    required this.language,
    required this.status,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE0EFFF) : Colors.transparent,
          border: Border.all(
            color: isSelected ? const Color(0xFF0056B3) : const Color(0xFFE2E8F0),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  language,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF1E293B) : const Color(0xFF475569),
                    fontFamily: language == 'አማርኛ' ? 'Noto Sans Ethiopic' : 'Plus Jakarta Sans',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? const Color(0xFF0056B3) : const Color(0xFF94A3B8),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF0056B3),
              ),
          ],
        ),
      ),
    );
  }
}
