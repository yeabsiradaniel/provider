import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/provider_profile/domain/models/provider_profile.dart';
import 'package:mobile/features/provider_profile/domain/services/provider_profile_service.dart';
import 'dart:developer';

class ProviderProfileNotifier extends StateNotifier<AsyncValue<ProviderProfile?>> {
  final ProviderProfileService _profileService;
  final String _userId;

  ProviderProfileNotifier(this._profileService, this._userId) : super(const AsyncValue.loading()) {
    fetchProviderProfile();
  }

  Future<void> fetchProviderProfile() async {
    state = const AsyncValue.loading();
    try {
      final profile = await _profileService.getMe();
      state = AsyncValue.data(profile);
    } catch (e, stack) {
      log('Error fetching provider profile:', error: e, stackTrace: stack);
      state = AsyncValue.error(e, stack);
    }
  }

  void updateProviderProfile(ProviderProfile newProfile) {
    state = AsyncValue.data(newProfile);
  }
}

final providerProfileServiceProvider =
    Provider.autoDispose<ProviderProfileService>((ref) => ProviderProfileService());

final providerProfileProvider = StateNotifierProvider.family<ProviderProfileNotifier, AsyncValue<ProviderProfile?>, String>((ref, userId) {
  return ProviderProfileNotifier(ref.watch(providerProfileServiceProvider), userId);
});
