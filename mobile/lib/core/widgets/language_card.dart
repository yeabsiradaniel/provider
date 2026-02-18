import 'package:flutter/material.dart';
import 'package:mobile/core/widgets/asym_card.dart';

class LanguageCard extends StatelessWidget {
  const LanguageCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.isSelected = false,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AsymCard(
        color: isSelected ? Colors.blue.shade50 : Theme.of(context).cardColor,
        borderColor: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).dividerColor,
        borderWidth: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.tertiary,
                      ),
                ),
              ],
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }
}
