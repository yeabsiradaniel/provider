import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/config.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/chat/domain/services/chat_service.dart';
import 'package:mobile/features/chat/presentation/screens/chat_screen.dart';
import 'package:mobile/features/chat/presentation/screens/provider_chat_screen.dart';
import 'package:mobile/features/user/domain/models/user.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  final ChatService _chatService = ChatService();
  List<Job> _conversations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchConversations();
  }

  Future<void> _fetchConversations() async {
    if (kDebugMode) {
      log('===== CUSTOMER CHAT LIST NAVIGATION =====');
    }
    try {
      final jobs = await _chatService.getConversations();
      if (kDebugMode) {
        log('===== CUSTOMER CHAT LIST PARSED MODEL =====');
        log('Parsed conversations count: ${jobs.length}');
      }
      if (mounted) {
        setState(() {
          if (kDebugMode) {
            log('===== CUSTOMER CHAT LIST STATE UPDATE =====');
            log('Updating state with ${jobs.length} conversations.');
          }
          _conversations = jobs;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        log('Error fetching conversations: $e');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      log('===== CUSTOMER CHAT LIST UI BUILD =====');
      log('Final list length used by UI: ${_conversations.length}');
    }
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chat),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _conversations.isEmpty
              ? Center(child: Text("You have no active chats."))
              : ListView.builder(
                  itemCount: _conversations.length,
                  itemBuilder: (context, index) {
                    final job = _conversations[index];
                    return _buildChatItem(context, job: job);
                  },
                ),
    );
  }

  Widget _buildChatItem(BuildContext context, {required Job job}) {
    final currentUser = ref.watch(userProvider).value;
    final bool isProvider = currentUser?.role == 'provider';

    // Determine the other user in the chat
    final User? otherUser = isProvider ? job.clientId : job.providerId;

    ImageProvider? backgroundImage;
    final photoPath = otherUser?.profilePhoto;

    if (photoPath != null && photoPath.isNotEmpty) {
      if (photoPath.startsWith('/uploads/')) {
        backgroundImage = NetworkImage('$baseUrl$photoPath');
      } else if (photoPath.startsWith('http')) {
        backgroundImage = NetworkImage(photoPath);
      }
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: backgroundImage,
        child: backgroundImage == null
            ? Text(otherUser?.firstName.substring(0, 1) ?? '?')
            : null,
      ),
      title: Text(otherUser?.firstName ?? 'Chat'),
      subtitle: Text(job.serviceName), // This could be the last message
      onTap: () {
        // Navigate to the correct chat screen based on user role
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              if (isProvider) {
                return ProviderChatScreen(job: job);
              } else {
                return ChatScreen(job: job);
              }
            },
          ),
        );
      },
    );
  }
}
