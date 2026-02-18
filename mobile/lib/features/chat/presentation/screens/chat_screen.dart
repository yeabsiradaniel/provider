import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/services/socket_service.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/chat/domain/models/message.dart';
import 'package:mobile/features/chat/domain/services/chat_service.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'dart:developer';

class ChatScreen extends ConsumerStatefulWidget {
  final Job job;
  const ChatScreen({Key? key, required this.job}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  
  List<Message> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    
    final socketService = ref.read(socketServiceProvider);
    socketService.joinJobRoom(widget.job.id);
    socketService.listenForMessages((data) {
       final message = Message.fromJson(data);
       if (mounted) {
        setState(() {
          _messages.add(message);
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _fetchMessages() async {
    try {
      final messages = await _chatService.getMessages(widget.job.id);
      if (mounted) {
        setState(() {
          _messages = messages;
          _isLoading = false;
        });
      }
    } catch (e) {
      log('Error fetching messages: $e');
       if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    final user = ref.read(userProvider).value;
    if (user == null) return;

    final messageData = {
      'jobId': widget.job.id,
      'senderId': user.id,
      'receiverId': widget.job.providerId,
      'text': _messageController.text,
    };
    
    try {
      await _chatService.postMessage(messageData);
      ref.read(socketServiceProvider).sendMessage(messageData);
      _messageController.clear();
    } catch (e) {
      log('Error sending message: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(userProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Provider'),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isMe = message.senderId == currentUser?.id;
                  return _MessageBubble(isMe: isMe, text: message.text);
                },
              ),
            ),
            _MessageInputField(controller: _messageController, onSend: _sendMessage),
          ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  const _MessageBubble({required this.isMe, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? Theme.of(context).colorScheme.primary : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

class _MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _MessageInputField({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
