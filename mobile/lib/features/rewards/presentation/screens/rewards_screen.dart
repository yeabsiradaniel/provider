import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: Text(l10n.rewardsScreen),
      ),
    );
  }
}
