import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile/features/auth/domain/services/auth_exception.dart';
import 'package:mobile/features/auth/domain/services/auth_service.dart';
import 'package:mobile/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:mobile/features/auth/presentation/screens/otp_screen.dart';
import 'package:mobile/features/auth/presentation/screens/registration_screen.dart';
import 'package:mobile/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:mobile/features/auth/presentation/widgets/phone_input.dart';
import 'package:mobile/features/auth/presentation/widgets/toggle_button.dart';
import 'package:mobile/features/language_selection/presentation/widgets/asymmetric_button.dart';
import 'package:mobile/l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedRole = 0; // 0 for Customer, 1 for Provider
  bool _isLoading = false;

  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();

  final _authService = AuthService();

  void _onRoleChanged(int index) {
    setState(() {
      _selectedRole = index;
      _formKey.currentState?.reset();
    });
  }

  Future<void> _getOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final phoneNumber = '+251' + _phoneController.text;
      final userData = {
        'pin': _pinController.text,
        'role': _selectedRole == 0 ? 'client' : 'provider',
      };

      try {
        await _authService.requestOtp(phoneNumber);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                OtpScreen(phoneNumber: phoneNumber, userData: userData),
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
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.welcome,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontFamily: 'Noto Sans Ethiopic',
                    ),
                  ),
                  const SizedBox(height: 32),
                  RoleToggleButton(
                    onRoleChanged: _onRoleChanged,
                    customerText: l10n.customer,
                    providerText: l10n.provider,
                  ),
                  const SizedBox(height: 32),
                  PhoneInput(controller: _phoneController, labelText: l10n.phone),
                  const SizedBox(height: 16),
                  CustomTextField(
                    label: l10n.pin,
                    isNumeric: true,
                    maxLength: 6,
                    obscureText: true,
                    controller: _pinController,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Center(
                      child: Text(
                        l10n.forgotPin,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AsymmetricButton(
                    label: _isLoading ? l10n.sending : l10n.login,
                    onPressed: !_isLoading ? _getOtp : null,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: l10n.dontHaveAccount,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          children: [
                            TextSpan(
                              text: l10n.register,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
