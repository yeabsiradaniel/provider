import 'package:flutter/material.dart';
import 'package:mobile/l10n/app_localizations.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/Asset 1.png', // This is the original logo
                    width: 96,
                    height: 96,
                  ),
                  const SizedBox(height: 24),
                  Image.asset(
                    'assets/images/app_name.png', // This is the new "FIXADDIS" logo
                    width: 160,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.splashSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF475569),
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      fontFamily: 'Plus Jakarta Sans'
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
