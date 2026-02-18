import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/widgets/asym_button.dart';
import 'package:mobile/features/auth/auth_notifier.dart';
import 'package:mobile/features/auth/auth_state.dart';

class OtpVerificationScreen extends ConsumerWidget {
  final String phoneNumber;
  const OtpVerificationScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = TextEditingController();
    final authState = ref.watch(authNotifierProvider);

    void _verifyOtp() {
      if (otpController.text.length == 6) {
        ref.read(authNotifierProvider.notifier).verifyOtp(phoneNumber, otpController.text);
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(const SnackBar(content: Text('Please enter a 6-digit code.')));
      }
    }

    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Verification Code',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the 6-digit code sent to your phone.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Simple OTP input using a single text field
              TextField(
                controller: otpController,
                maxLength: 6,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 16),
                decoration: const InputDecoration(
                  counterText: "",
                  border: OutlineInputBorder(),
                  hintText: '------',
                ),
              ),
              const SizedBox(height: 32),
              if (authState is AuthLoading)
                const Center(child: CircularProgressIndicator())
              else
                AsymButton(
                  onPressed: _verifyOtp,
                  label: 'VERIFY',
                ),
                const SizedBox(height: 16),
                TextButton(onPressed: (){
                    // Resend code logic would go here
                }, child: const Text("Resend Code"))
            ],
          ),
        ),
      ),
    );
  }
}
