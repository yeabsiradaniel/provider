import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile/features/auth/domain/services/auth_exception.dart';
import 'package:mobile/features/auth/domain/services/auth_service.dart';
import 'package:mobile/features/auth/presentation/screens/login_screen.dart';
import 'package:mobile/features/auth/presentation/screens/otp_screen.dart';
import 'package:mobile/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:mobile/features/auth/presentation/widgets/phone_input.dart';
import 'package:mobile/features/auth/presentation/widgets/photo_upload.dart';
import 'package:mobile/features/auth/presentation/widgets/toggle_button.dart';
import 'package:mobile/features/language_selection/presentation/widgets/asymmetric_button.dart';
import 'package:mobile/l10n/app_localizations.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _selectedRole = 0; // 0 for Customer, 1 for Provider
  bool _isLoading = false;

  final _phoneController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _pinController = TextEditingController();
  File? _profilePhoto;
  File? _idPhoto;

  final _authService = AuthService();

  void _onRoleChanged(int index) {
    setState(() {
      _selectedRole = index;
    });
  }

  Future<void> _getOtp() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == 1 && _idPhoto == null) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.pleaseUploadIdPhoto)),
        );
        return;
      }
      
      setState(() {
        _isLoading = true;
      });

      final phoneNumber = '+251' + _phoneController.text;
      final userData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'pin': _pinController.text,
        'role': _selectedRole == 0 ? 'client' : 'provider',
        'profilePhoto': _profilePhoto,
        'idPhoto': _idPhoto,
      };

      try {
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
    _firstNameController.dispose();
    _lastNameController.dispose();
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
                  const SizedBox(height: 24),
                  Text(
                    l10n.welcome,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.createYourAccount,
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
                  if (_selectedRole == 0)
                    ..._buildCustomerFields(l10n)
                  else
                    ..._buildProviderFields(l10n),
                  const SizedBox(height: 32),
                  AsymmetricButton(
                    label: _isLoading ? l10n.sending.toUpperCase() : l10n.getOtp,
                    onPressed: !_isLoading ? _getOtp : null,
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) => const LoginScreen(),
                          transitionDuration: Duration.zero,
                        ),
                      );
                    },
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: l10n.alreadyHaveAccount,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                          children: [
                            TextSpan(
                              text: l10n.login,
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

  List<Widget> _buildCustomerFields(AppLocalizations l10n) {
    return [
      Center(
        child: PhotoUpload(
          label: l10n.profilePhoto,
          isRequired: false,
          isCircular: true,
          height: 120,
          width: 120,
          onImageSelected: (file) {
            setState(() {
              _profilePhoto = file;
            });
          },
        ),
      ),
      const SizedBox(height: 24),
      CustomTextField(
          label: l10n.firstName, controller: _firstNameController, hintText: l10n.enterYourFirstName),
      const SizedBox(height: 16),
      CustomTextField(label: l10n.lastName, controller: _lastNameController, hintText: l10n.enterYourLastName),
      const SizedBox(height: 16),
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
    ];
  }

  List<Widget> _buildProviderFields(AppLocalizations l10n) {
    return [
      Center(
        child: PhotoUpload(
          label: l10n.profilePhoto,
          isCircular: true,
          height: 120,
          width: 120,
          onImageSelected: (file) {
            setState(() {
              _profilePhoto = file;
            });
          },
        ),
      ),
      const SizedBox(height: 24),
      CustomTextField(
          label: l10n.firstName, controller: _firstNameController, hintText: l10n.enterYourFirstName),
      const SizedBox(height: 16),
      CustomTextField(label: l10n.lastName, controller: _lastNameController, hintText: l10n.enterYourLastName),
      const SizedBox(height: 16),
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
      const SizedBox(height: 24),
      PhotoUpload(
        label: l10n.idUpload,
        onImageSelected: (file) {
          setState(() {
            _idPhoto = file;
          });
        },
      ),
    ];
  }
}
