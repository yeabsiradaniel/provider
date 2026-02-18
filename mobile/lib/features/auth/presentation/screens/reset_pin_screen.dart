import 'package:flutter/material.dart';
import 'package:mobile/features/auth/domain/services/auth_exception.dart';
import 'package:mobile/features/auth/domain/services/auth_service.dart';
import 'package:mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:mobile/features/language_selection/presentation/widgets/asymmetric_button.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ResetPinScreen extends StatefulWidget {
  final String phoneNumber;

  const ResetPinScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _ResetPinScreenState createState() => _ResetPinScreenState();
}

class _ResetPinScreenState extends State<ResetPinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _newPinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _isLoading = false;
  final _authService = AuthService();

  Future<void> _resetPin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _authService.resetPin(
            widget.phoneNumber, _otpController.text, _newPinController.text);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (Route<dynamic> route) => false,
        );
      } on AuthException catch (e) {
        final l10n = AppLocalizations.of(context)!;
        String displayMessage;

        switch (e.code) {
          case 'OTP_INVALID':
            displayMessage = l10n.otpExpiredOrInvalid; // Reusing this for simplicity, can add a specific 'otpInvalid' if needed
            break;
          case 'USER_NOT_FOUND':
            displayMessage = l10n.registrationRequiredMessage; // Reusing for simplicity, can add specific message for PIN reset
            break;
          default:
            displayMessage = l10n.genericError;
            break;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(displayMessage)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.forgotPin),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.resetPin,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _otpController,
                  label: 'OTP', // No localized string for OTP label? Use default if not.
                  isNumeric: true,
                  maxLength: 6,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _newPinController,
                  label: l10n.pin, // Assuming 'pin' can be reused for 'New Pin'
                  isNumeric: true,
                  maxLength: 6,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _confirmPinController,
                  label: l10n.confirmPin, // New localized string
                  isNumeric: true,
                  maxLength: 6,
                  obscureText: true,
                  customValidator: (value) {
                    if (value != _newPinController.text) {
                      return l10n.pinsDoNotMatch; // New localized string
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                AsymmetricButton(
                  label: _isLoading ? l10n.resetting : l10n.resetPin, // New localized strings
                  onPressed: !_isLoading ? _resetPin : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
