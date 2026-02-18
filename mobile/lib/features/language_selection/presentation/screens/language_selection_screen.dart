import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/language_selection/presentation/widgets/asymmetric_button.dart';
import 'package:mobile/features/language_selection/presentation/widgets/language_card.dart';
import 'package:mobile/features/auth/presentation/screens/registration_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'package:mobile/main.dart';

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
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.selectYourLanguage,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Noto Sans Ethiopic',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.language.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48), // Spacing after title/subtitle
              Column(
                children: [
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
                ],
              ),
              const SizedBox(height: 48), // Spacing before button
              AsymmetricButton(
                label: AppLocalizations.of(context)!.continueButton,
                onPressed: () {
                  final selectedLang =
                      selectedIndex == 0 ? 'አማርኛ' : 'English';
                  onLanguageSelected(selectedLang);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegistrationScreen()),
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
