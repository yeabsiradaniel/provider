import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For now, this is a placeholder.
    // In a real app, you'd have buttons for 'Customer' and 'Provider'
    // that would call ref.read(authNotifierProvider.notifier).selectRole(...);
    return const Scaffold(
      body: Center(
        child: Text('Role Selection Screen - Placeholder'),
      ),
    );
  }
}
