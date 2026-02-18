import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile/core/widgets/profile_avatar.dart';
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        Navigator.of(context).pop();
      } catch (e) {
        log('Error updating profile: $e');
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editProfile),
      ),
      body: user == null
          ? const Center(child: Text('User not found.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    if (_profileImage != null)
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: FileImage(_profileImage!),
                      )
                    else
                      ProfileAvatar(
                        imageUrl: user.profilePhoto ?? '',
                        radius: 60,
                      ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _pickImage,
                      child: Text(l10n.changeProfilePhoto),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: l10n.firstName),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.fieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(labelText: l10n.lastName),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.fieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: InputDecoration(labelText: l10n.phone),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return l10n.fieldRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(l10n.updateProfile),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
