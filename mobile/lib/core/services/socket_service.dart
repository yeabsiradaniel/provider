import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/review/presentation/screens/rating_screen.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:developer';

import 'package:mobile/features/bookings/domain/providers/booking_provider.dart';
import 'package:mobile/features/provider_earnings/domain/providers/provider_earnings_provider.dart';
import 'package:mobile/features/provider_schedule/domain/providers/provider_schedule_provider.dart';

class SocketService {
  final Ref _ref;
  IO.Socket? _socket;
  BuildContext? _context;

  SocketService(this._ref);

  void initSocket(BuildContext context) {
    _context = context;
    _socket = IO.io('http://10.0.2.2:3001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
    _socket!.connect();
    _socket!.onConnect((_) {
      log('Socket connected');
      _listenToEvents();
    });
    _socket!.onDisconnect((_) => log('Socket disconnected'));
  }

  void _listenToEvents() {
    _socket!.on('jobAccepted', (_) {
      log('Received jobAccepted event');
      _ref.refresh(customerBookingsProvider);
      _ref.refresh(providerScheduleProvider);
    });

    _socket!.on('jobFinished', (data) {
      log('Received jobFinished event with data: $data');
      _ref.refresh(customerBookingsProvider);
      _ref.refresh(providerScheduleProvider);
      _ref.refresh(providerEarningsProvider);
      
      if (_context != null && data is Map<String, dynamic>) {
        showDialog(
          context: _context!,
          builder: (context) => RatingScreen(
            jobId: data['_id'],
            providerId: data['providerId'],
          ),
        );
      }
    });
  }

  void joinJobRoom(String jobId) {
    _socket?.emit('joinJobRoom', jobId);
  }

   void sendMessage(Map<String, dynamic> data) {
    _socket?.emit('sendMessage', data);
  }

  void listenForMessages(Function(dynamic) handler) {
    _socket?.on('receiveMessage', handler);
  }

  void dispose() {
    _socket?.dispose();
  }
}

final socketServiceProvider = Provider.autoDispose<SocketService>((ref) {
  // This is a bit of a hack to get the context, a proper solution would use a navigation service
  final context = ref.watch(navigatorKeyProvider).currentContext;
  final socketService = SocketService(ref);
  if (context != null) {
    socketService.initSocket(context);
  }
  ref.onDispose(() => socketService.dispose());
  return socketService;
});

final navigatorKeyProvider = Provider((ref) => GlobalKey<NavigatorState>());
