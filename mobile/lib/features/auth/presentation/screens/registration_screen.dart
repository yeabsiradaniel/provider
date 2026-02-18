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
      _formKey.currentState?.reset();
      _profilePhoto = null;
      _idPhoto = null;
    });
  }

  Future<void> _getOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      final phoneNumber = '+251' + _phoneController.text;
      final userData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'pin': _pinController.text,
        'role': _selectedRole == 0 ? 'client' : 'provider',
        'profilePhoto': _profilePhoto?.path ?? '',
        'idPhoto': _idPhoto?.path ?? '',
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
    _firstNameController.dispose();
    _lastNameController.dispose();
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
                  if (_selectedRole == 0)
                    ..._buildCustomerFields(l10n)
                  else
                    ..._buildProviderFields(l10n),
                  const SizedBox(height: 32),
                  AsymmetricButton(
                    label: _isLoading ? l10n.sending : l10n.getOtp,
                    onPressed: !_isLoading ? _getOtp : null,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          text: l10n.alreadyHaveAccount,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                          children: [
                            TextSpan(
                              text: l10n.login,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
          width: 150,
          onImageSelected: (file) {
            setState(() {
              _profilePhoto = file;
            });
          },
        ),
      ),
      const SizedBox(height: 16),
      PhoneInput(controller: _phoneController, labelText: l10n.phone),
      const SizedBox(height: 16),
      CustomTextField(
          label: l10n.firstName, controller: _firstNameController),
      const SizedBox(height: 16),
      CustomTextField(label: l10n.lastName, controller: _lastNameController),
      const SizedBox(height: 16),
      CustomTextField(
        label: l10n.pin,
        isNumeric: true,
        maxLength: 6,
        obscureText: true,
        controller: _pinController,
      ),
    ];
  }

  List<Widget> _buildProviderFields(AppLocalizations l10n) {
    return [
      Center(
        child: PhotoUpload(
          label: l10n.profilePhoto,
          width: 150,
          onImageSelected: (file) {
            setState(() {
              _profilePhoto = file;
            });
          },
        ),
      ),
      const SizedBox(height: 16),
      PhoneInput(controller: _phoneController, labelText: l10n.phone),
      const SizedBox(height: 16),
      CustomTextField(
          label: l10n.firstName, controller: _firstNameController),
      const SizedBox(height: 16),
      CustomTextField(label: l10n.lastName, controller: _lastNameController),
      const SizedBox(height: 16),
      CustomTextField(
        label: l10n.pin,
        isNumeric: true,
        maxLength: 6,
        obscureText: true,
        controller: _pinController,
      ),
      const SizedBox(height: 16),
      PhotoUpload(
        label: l10n.idUpload,
        width: double.infinity,
        onImageSelected: (file) {
          setState(() {
            _idPhoto = file;
          });
        },
      ),
    ];
  }
}
