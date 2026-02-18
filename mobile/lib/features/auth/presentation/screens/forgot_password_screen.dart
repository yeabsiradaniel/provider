import 'package:flutter/material.dart';
import 'package:mobile/features/auth/domain/services/auth_exception.dart';
import 'package:mobile/features/auth/domain/services/auth_service.dart';
import 'package:mobile/features/auth/presentation/screens/reset_pin_screen.dart';
import 'package:mobile/features/auth/presentation/widgets/phone_input.dart';
import 'package:mobile/features/language_selection/presentation/widgets/asymmetric_button.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  final _authService = AuthService();

  Future<void> _sendOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final phoneNumber = '+251' + _phoneController.text;
      try {
        await _authService.requestOtp(phoneNumber);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResetPinScreen(phoneNumber: phoneNumber),
          ),
        );
      } on AuthException catch (e) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message)), // Using e.message which is user-friendly
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
    _phoneController.dispose();
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
                  l10n.forgotPin,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),
                PhoneInput(
                  controller: _phoneController,
                  labelText: l10n.phone,
                ),
                const SizedBox(height: 32),
                AsymmetricButton(
                  label: _isLoading ? l10n.sending : 'SEND OTP',
                  onPressed: !_isLoading ? _sendOtp : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
