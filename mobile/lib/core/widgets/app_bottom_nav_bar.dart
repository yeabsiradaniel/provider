import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      surfaceTintColor: Colors.white, // From html `bg-white`
      elevation: 0,
      child: Container(
        height: 64, // From html `height: 64px`
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor, // From html `border-top: 1px solid #f1f5f9;`
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(context, Icons.home, 0, 'Home'),
            _buildNavItem(context, Icons.receipt_long, 1, 'Receipts'),
            _buildNavItem(context, Icons.forum, 2, 'Chat'),
            _buildNavItem(context, Icons.person, 3, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      BuildContext context, IconData icon, int index, String label) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.tertiary, // text-slate-300
            weight: isSelected ? 700 : 400, // font-black for selected
          ),
          // You might want to add a label below the icon if needed
          // Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
