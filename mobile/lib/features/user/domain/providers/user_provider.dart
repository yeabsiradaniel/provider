import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/user/domain/models/user.dart';
import 'package:mobile/features/user/domain/services/user_service.dart';

// State Notifier
class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final UserService _userService;

  UserNotifier(this._userService) : super(const AsyncValue.loading());

  Future<void> fetchUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await _userService.getMe();
      state = AsyncValue.data(user);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void updateUser(User newUser) {
    log('UserProvider: State updated with new user data. New profilePhoto ID: ${newUser.profilePhoto}');
    state = AsyncValue.data(newUser);
  }

  void clearUser() {
    state = const AsyncValue.data(null);
  }
}

// Service Provider (if you want to mock it in tests)
final userServiceProvider = Provider<UserService>((ref) => UserService());

// StateNotifierProvider
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  return UserNotifier(ref.watch(userServiceProvider));
});
