import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_service.dart';
import 'auth_state.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(const AuthInitial()) {
    _init();
  }

  void _init() async {
    state = const AuthLoading();
    final user = await _authService.getLoggedInUser();
    if (user != null) {
      state = AuthAuthenticated(user);
    } else {
      state = const AuthUnauthenticated();
    }
  }

  Future<void> requestOtp(String phoneNumber) async {
    state = const AuthLoading();
    try {
      await _authService.requestOtp(phoneNumber);
      state = const AuthCodeSent();
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    state = const AuthLoading();
    try {
      final user = await _authService.verifyOtp(phoneNumber, otp);
      state = AuthAuthenticated(user);
    } catch (e) {
      state = AuthError(e.toString());
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AuthUnauthenticated();
  }
}
