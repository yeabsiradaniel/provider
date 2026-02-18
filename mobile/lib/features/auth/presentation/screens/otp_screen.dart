import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/domain/services/auth_exception.dart';
import 'package:mobile/features/auth/domain/services/auth_service.dart';
import 'package:mobile/features/auth/presentation/screens/registration_screen.dart';
import 'package:mobile/features/client_dashboard/presentation/screens/client_home_screen.dart';
import 'package:mobile/features/provider_dashboard/presentation/screens/category_selection_screen.dart';
import 'package:mobile/features/provider_dashboard/presentation/screens/provider_dashboard_screen.dart';
import 'package:mobile/features/provider_profile/domain/providers/provider_profile_provider.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:mobile/features/language_selection/presentation/widgets/asymmetric_button.dart';
import 'package:mobile/l10n/app_localizations.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  final Map<String, String> userData;

  const OtpScreen({Key? key, required this.phoneNumber, required this.userData})
      : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  final _authService = AuthService();

  Future<void> _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        log('---- OTP SCREEN: Verifying OTP ----');
        final response = await _authService.verifyOtp(
            widget.phoneNumber, _otpController.text, widget.userData);
        log('[OtpScreen] Raw response from authService: $response');
        
        await ref.read(userProvider.notifier).fetchUser();
        
        final userRole = response['user']['role'];
        final isNewUser = response['isNewUser'] ?? false;
        log('[OtpScreen] Extracted userRole: $userRole, isNewUser: $isNewUser');

        if (userRole == 'client') {
          log('[OtpScreen] Navigating to ClientHomeScreen.');
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ClientHomeScreen()),
            (Route<dynamic> route) => false,
          );
        } else if (userRole == 'provider') {
          if (isNewUser) {
            log('[OtpScreen] New provider detected. Navigating to CategorySelectionScreen.');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const CategorySelectionScreen()),
              (Route<dynamic> route) => false,
            );
          } else {
            log('[OtpScreen] Existing provider detected. Navigating to ProviderDashboardScreen.');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const ProviderDashboardScreen()),
              (Route<dynamic> route) => false,
            );
          }
        }
        log('---------------------------------');
      } on AuthException catch (e) {
        final l10n = AppLocalizations.of(context)!;
        String displayMessage;

        if (e.code == 'USER_NOT_FOUND') {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: Text(l10n.registrationRequiredTitle),
                content: Text(l10n.registrationRequiredMessage),
                actions: <Widget>[
                  TextButton(
                    child: Text(l10n.register),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                  ),
                  TextButton(
                    child: Text(l10n.cancel),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              );
            },
          );
          return;
        } else if (e.code == 'USER_ALREADY_EXISTS') {
          displayMessage = l10n.userAlreadyExists;
        } else if (e.code == 'INVALID_CREDENTIALS') {
          displayMessage = l10n.invalidCredentials;
        } else if (e.code == 'OTP_EXPIRED_OR_INVALID') {
          displayMessage = l10n.otpExpiredOrInvalid;
        } else if (e.code == 'OTP_TOO_MANY_ATTEMPTS') {
          displayMessage = l10n.otpTooManyAttempts;
        } else {
          displayMessage = l10n.genericError;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(displayMessage)),
        );
      } finally {
        if(mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.enterOtp,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.otpSentTo(widget.phoneNumber),
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.fieldRequired;
                    }
                    if (value.length != 6) {
                      return l10n.otpMustBe6Digits;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'OTP',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: Theme.of(context).disabledColor,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AsymmetricButton(
                  label: _isLoading ? l10n.verifying : l10n.verify,
                  onPressed: _isLoading ? null : _verifyOtp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
