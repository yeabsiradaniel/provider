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
    try {
      final jobs = await _chatService.getConversations();
      if (mounted) {
        setState(() {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchConversations,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    floating: true,
                    pinned: true,
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    elevation: 0,
                    title: Text(
                      l10n.chat,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (_conversations.isEmpty)
                    const SliverFillRemaining(
                      child: Center(
                        child: Text(
                          "You have no active chats.",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final job = _conversations[index];
                            return _buildChatItem(context, job: job);
                          },
                          childCount: _conversations.length,
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildChatItem(BuildContext context, {required Job job}) {
    final currentUser = ref.watch(userProvider).value;
    final bool isProvider = currentUser?.role == 'provider';

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

    return InkWell(
      onTap: () {
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade100),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                shape: BoxShape.circle,
                image: backgroundImage != null
                    ? DecorationImage(
                        image: backgroundImage,
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: backgroundImage == null
                  ? Center(
                      child: Text(
                        otherUser?.firstName.substring(0, 1) ?? '?',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUser?.firstName ?? 'Chat',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    job.serviceName,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.grey.shade400,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
