import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/services/socket_service.dart';
import 'package:mobile/features/user/domain/models/user.dart';
import 'package:mobile/features/user/domain/services/user_service.dart';

import 'package:mobile/core/services/notification_service.dart';

// State Notifier
class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final UserService _userService;
  final Ref _ref;

  UserNotifier(this._userService, this._ref) : super(const AsyncValue.loading());

  Future<void> fetchUser() async {
    state = const AsyncValue.loading();
    try {
      final user = await _userService.getMe();
      state = AsyncValue.data(user);
      if (user != null) {
        // When user is fetched successfully, initialize services
        log('--- [LOG] UserNotifier: User fetched. Initializing services. ---');
        _ref.read(socketServiceProvider).initSocket();
        
        final notificationService = _ref.read(notificationServiceProvider);
        await notificationService.init();
        await notificationService.requestPermissions();
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  void updateUser(User newUser) {
    log('UserProvider: State updated with new user data. New profilePhoto ID: ${newUser.profilePhoto}');
    state = AsyncValue.data(newUser);
  }

  void clearUser() {
    log('--- [LOG] UserNotifier: Clearing user. Disposing socket. ---');
    _ref.read(socketServiceProvider).dispose();
    state = const AsyncValue.data(null);
  }
}

// Service Provider (if you want to mock it in tests)
final userServiceProvider = Provider<UserService>((ref) => UserService());

// StateNotifierProvider
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  return UserNotifier(ref.watch(userServiceProvider), ref);
});
