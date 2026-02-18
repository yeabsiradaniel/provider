import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/widgets/asym_button.dart';
import 'package:mobile/core/widgets/labeled_text_field.dart';
import 'package:mobile/features/auth/auth_notifier.dart';
import 'package:mobile/features/auth/auth_state.dart';
import 'otp_verification_screen.dart';

class PhoneInputScreen extends ConsumerWidget {
  const PhoneInputScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneController = TextEditingController();
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthCodeSent) {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(phoneNumber: '+251${phoneController.text}'),
        ));
      } else if (next is AuthError) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next.message)));
      }
    });

    void _getOtp() {
      // Basic validation
      if (phoneController.text.isNotEmpty) {
        final fullPhoneNumber = '+251${phoneController.text}';
        ref.read(authNotifierProvider.notifier).requestOtp(fullPhoneNumber);
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Please enter a phone number.')));
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'እንኳን ደህና መጡ',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Welcome',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              LabeledTextField(
                label: 'Phone',
                prefixText: '+251',
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              if (authState is AuthLoading)
                const Center(child: CircularProgressIndicator())
              else
                AsymButton(
                  onPressed: _getOtp,
                  label: 'GET OTP',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
