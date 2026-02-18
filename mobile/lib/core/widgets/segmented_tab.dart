import 'package:flutter/material.dart';
import 'package:mobile/core/theme/radius.dart';

class SegmentedTab extends StatelessWidget {
  const SegmentedTab({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSegmentSelected,
  });

  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSegmentSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16), // Rounded-2xl from html was 16px
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(options.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSegmentSelected(index),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).cardColor // Assuming white for selected background
                      : Colors.transparent,
                  borderRadius: AppRadius.cardRadius, // Uses asym-card radius for selected segment
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  options[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary // blue for selected
                            : Theme.of(context).colorScheme.onSurface, // slate-400 for unselected
                        fontWeight: FontWeight.w900, // black font from html
                      ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
