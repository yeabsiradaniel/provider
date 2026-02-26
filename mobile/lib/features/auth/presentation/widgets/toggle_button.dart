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
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
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
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
