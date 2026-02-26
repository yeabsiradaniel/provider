import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/language_selection/presentation/widgets/asymmetric_button.dart';
import 'package:mobile/features/language_selection/presentation/widgets/language_card.dart';
import 'package:mobile/features/auth/presentation/screens/registration_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  final Function(String) onLanguageSelected;
  final String? selectedLanguage;

  const LanguageSelectionScreen({
    Key? key,
    required this.onLanguageSelected,
    this.selectedLanguage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final selectedIndex = locale.languageCode == 'am' ? 0 : 1;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                AppLocalizations.of(context)!.selectYourLanguage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.language.toUpperCase(),
                 textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade500,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              LanguageCard(
                language: 'አማርኛ',
                status: AppLocalizations.of(context)!.defaultStatus,
                isSelected: selectedIndex == 0,
                onTap: () {
                  ref.read(localeProvider.notifier).state = const Locale('am');
                },
              ),
              const SizedBox(height: 16),
              LanguageCard(
                language: 'English',
                status: AppLocalizations.of(context)!.supported,
                isSelected: selectedIndex == 1,
                onTap: () {
                  ref.read(localeProvider.notifier).state = const Locale('en');
                },
              ),
              const Spacer(flex: 2),
              AsymmetricButton(
                label: AppLocalizations.of(context)!.continueButton,
                onPressed: () async {
                  final selectedLang =
                      selectedIndex == 0 ? 'አማርኛ' : 'English';
                  onLanguageSelected(selectedLang);
                  
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('hasCompletedOnboarding', true);

                  // Replace the whole onboarding stack with the registration screen
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
