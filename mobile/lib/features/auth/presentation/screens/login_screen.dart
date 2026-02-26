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
    });
  }

  Future<void> _login() async {
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
        // NOTE: In a real login flow, this would call a login endpoint,
        // not request OTP. Reusing for this project's structure.
        await _authService.requestOtp(phoneNumber);
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  OtpScreen(phoneNumber: phoneNumber, userData: userData),
            ),
          );
        }
      } on AuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message)),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 48),
                  Text(
                    l10n.welcomeBack,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.loginToYourAccount,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
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
                    hintText: l10n.enter6DigitPIN,
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
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        l10n.forgotPin,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AsymmetricButton(
                    label: _isLoading ? l10n.sending.toUpperCase() : l10n.login,
                    onPressed: !_isLoading ? _login : null,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                       Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => const RegistrationScreen(),
                          transitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: l10n.dontHaveAccount,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: l10n.register,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
