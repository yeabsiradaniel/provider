import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // For now, this is a placeholder.
    // In a real app, you'd have buttons for 'Customer' and 'Provider'
    // that would call ref.read(authNotifierProvider.notifier).selectRole(...);
    return Scaffold(
      body: Center(
        child: Text(l10n.roleSelectionScreenPlaceholder),
      ),
    );
  }
}
