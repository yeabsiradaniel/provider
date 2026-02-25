import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/review/presentation/screens/rating_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:mobile/features/bookings/domain/providers/booking_provider.dart';
import 'package:mobile/features/provider_earnings/domain/providers/provider_earnings_provider.dart';
import 'package:mobile/features/provider_schedule/domain/providers/provider_schedule_provider.dart';

class SocketService {
  final Ref _ref;
  IO.Socket? _socket;

  SocketService(this._ref);

  void initSocket() async {
    log('--- [LOG] SocketService: initSocket called. ---');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      log('--- [LOG] SocketService: No token found. Socket connection aborted. ---');
      return;
    }

    final url = 'http://10.0.2.2:3001';
    log('--- [LOG] SocketService: Attempting to connect to $url with token. ---');

    _socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'auth': {'token': token} // Send token for authentication
    });

    _socket!.on('connect', (_) {
      log('--- [LOG] SocketService: Socket connected and authenticated successfully. ---');
      _listenToEvents();
    });

    _socket!.on('connect_error',
        (data) => log('--- [LOG] SocketService: onConnectError - $data ---'));
    _socket!
        .on('error', (data) => log('--- [LOG] SocketService: onError - $data ---'));
    _socket!.on('disconnect',
        (_) => log('--- [LOG] SocketService: Socket disconnected. ---'));
  }

  void _listenToEvents() {
    log('--- [LOG] SocketService: Registering event listeners. ---');

    _socket!.on('newJobRequest', (_) {
      log('--- [LOG] SocketService: Received newJobRequest event ---');
      _ref.read(newRequestNotifierProvider.notifier).notify();
    });

    _socket!.on('jobAccepted', (_) {
      log('--- [LOG] SocketService: Received jobAccepted event ---');
      _ref.refresh(customerBookingsProvider);
      _ref.refresh(providerScheduleProvider);
    });

    _socket!.on('jobFinished', (data) {
      log('--- [LOG] SocketService: Received jobFinished event with data: $data ---');
      _ref.refresh(customerBookingsProvider);
      _ref.refresh(providerScheduleProvider);
      _ref.refresh(providerEarningsProvider);

      // Use the navigator key to get a context for the dialog
      final context = _ref.read(navigatorKeyProvider).currentContext;
      if (context != null && data is Map<String, dynamic>) {
        log('--- [LOG] SocketService: Showing RatingScreen dialog via Navigator key. ---');
        showDialog(
          context: context,
          builder: (context) => RatingScreen(
            jobId: data['_id'],
            providerId: data['providerId'],
          ),
        );
      } else {
        log('--- [LOG] SocketService: FAILED to show RatingScreen dialog. Context or data missing. ---');
      }
    });
  }

  void joinJobRoom(String jobId) {
    log('--- [LOG] SocketService: Emitting joinJobRoom for $jobId ---');
    _socket?.emit('joinJobRoom', jobId);
  }

  void sendMessage(Map<String, dynamic> data) {
    log('--- [LOG] SocketService: Emitting sendMessage ---');
    _socket?.emit('sendMessage', data);
  }

  void listenForMessages(Function(dynamic) handler) {
    log('--- [LOG] SocketService: Attaching listener for receiveMessage event. ---');
    _socket?.on('receiveMessage', (data) {
      log('--- [LOG] SocketService: Received receiveMessage event ---');
      handler(data);
    });
  }

  void dispose() {
    log('--- [LOG] SocketService: dispose called. ---');
    _socket?.dispose();
  }
}

// A simple provider to notify UI about new real-time requests
final newRequestNotifierProvider =
    StateNotifierProvider<NewRequestNotifier, int>((ref) {
  return NewRequestNotifier();
});

class NewRequestNotifier extends StateNotifier<int> {
  NewRequestNotifier() : super(0);
  void notify() => state++;
}

final socketServiceProvider = Provider<SocketService>((ref) {
  final socketService = SocketService(ref);
  return socketService;
});

final navigatorKeyProvider = Provider((ref) => GlobalKey<NavigatorState>());
