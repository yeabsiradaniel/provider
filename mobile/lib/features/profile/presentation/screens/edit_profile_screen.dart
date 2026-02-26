import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/widgets/profile_avatar.dart';
import 'package:mobile/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:mobile/features/user/domain/models/user.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:mobile/features/user/domain/services/user_service.dart';
import 'package:mobile/l10n/app_localizations.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider).value;
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
      _phoneController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        User? userWithNewImage;
        if (_profileImage != null) {
          log('Uploading new image...');
          userWithNewImage =
              await _userService.uploadProfilePicture(_profileImage!);
          log('Image uploaded, new File ID: ${userWithNewImage.profilePhoto}');
        }

        final updatedData = {
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'phone': _phoneController.text,
          if (userWithNewImage?.profilePhoto != null)
            'profilePhoto': userWithNewImage!.profilePhoto,
        };

        final updatedUser = await _userService.updateUser(updatedData);

        log('Updating user profile in provider with new data. New profilePhoto ID: ${updatedUser.profilePhoto}');
        ref.read(userProvider.notifier).updateUser(updatedUser);

        setState(() {
          _isLoading = false;
          _profileImage = null;
        });

        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileUpdatedSuccessfully)),
        );
        Navigator.of(context).pop();
      } catch (e) {
        log('Error updating profile: $e');
        setState(() {
          _isLoading = false;
        });
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.failedToUpdateProfile}${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider).value;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
      ),
      body: user == null
          ? Center(child: Text(l10n.userNotFound))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          if (_profileImage != null)
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: FileImage(_profileImage!),
                            )
                          else
                            ProfileAvatar(
                              imageUrl: user.profilePhoto ?? '',
                              radius: 50,
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.edit,
                                    color: theme.colorScheme.onPrimary, size: 16),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 48),
                    CustomTextField(
                      label: l10n.firstName,
                      controller: _firstNameController,
                      hintText: l10n.enterYourFirstName,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: l10n.lastName,
                      controller: _lastNameController,
                      hintText: l10n.enterYourLastName,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: l10n.phone,
                      controller: _phoneController,
                      isNumeric: true,
                    ),
                  ],
                ),
              ),
            ),
       bottomNavigationBar: Padding(
         padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
         child: ElevatedButton(
            onPressed: _isLoading ? null : _updateProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  )
                : Text(l10n.updateProfile),
          ),
       ),
    );
  }
}
