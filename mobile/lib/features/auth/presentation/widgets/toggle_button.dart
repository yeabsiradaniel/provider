import 'package:flutter/material.dart';

class RoleToggleButton extends StatefulWidget {
  final Function(int) onRoleChanged;
  final String customerText;
  final String providerText;

  const RoleToggleButton({
    Key? key,
    required this.onRoleChanged,
    required this.customerText,
    required this.providerText,
  }) : super(key: key);

  @override
  _RoleToggleButtonState createState() => _RoleToggleButtonState();
}

class _RoleToggleButtonState extends State<RoleToggleButton> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildButton(widget.customerText, 0),
          ),
          Expanded(
            child: _buildButton(widget.providerText, 1),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String text, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onRoleChanged(index);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: isSelected
                ? const Color(0xFF0056B3)
                : const Color(0xFF64748B),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
