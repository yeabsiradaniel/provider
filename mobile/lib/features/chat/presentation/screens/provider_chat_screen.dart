import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/services/socket_service.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/bookings/domain/services/job_service.dart';
import 'package:mobile/features/chat/domain/models/message.dart';
import 'package:mobile/features/chat/domain/services/chat_service.dart';
import 'package:mobile/features/provider_schedule/domain/providers/provider_schedule_provider.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';
import 'dart:developer';

class ProviderChatScreen extends ConsumerStatefulWidget {
  final Job job;
  const ProviderChatScreen({Key? key, required this.job}) : super(key: key);

  @override
  _ProviderChatScreenState createState() => _ProviderChatScreenState();
}

class _ProviderChatScreenState extends ConsumerState<ProviderChatScreen> {
  final JobService _jobService = JobService();
  final ChatService _chatService = ChatService();
  final TextEditingController _messageController = TextEditingController();
  
  List<Message> _messages = [];
  bool _isLoading = true;
  bool _isAccepting = false;
  bool _isDeclining = false;
  StreamSubscription? _messageSubscription;

  @override
  void initState() {
    super.initState();
    log('--- [LOG] ProviderChatScreen: initState ---');
    _fetchMessages();
    
    final socketService = ref.read(socketServiceProvider);
    socketService.joinJobRoom(widget.job.id);

    log('--- [LOG] ProviderChatScreen: Subscribing to message stream. ---');
    _messageSubscription = socketService.messageStream.listen((data) {
      log('--- [LOG] ProviderChatScreen: Message received from stream. ---');
      // Filter messages to ensure they belong to the current job
      if (data['jobId'] == widget.job.id) {
        final message = Message.fromJson(data);
        if (mounted) {
          setState(() {
            _messages.add(message);
          });
        }
      }
    });
  }

  @override
  void dispose() {
    log('--- [LOG] ProviderChatScreen: dispose ---');
    log('--- [LOG] ProviderChatScreen: Cancelling message subscription. ---');
    _messageSubscription?.cancel();
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
    if (user == null || widget.job.clientId == null) return;

    final messageData = {
      'jobId': widget.job.id,
      'senderId': user.id,
      'receiverId': widget.job.clientId!.id,
      'text': _messageController.text,
    };
    
    log('--- [LOG] ProviderChatScreen: Emitting sendMessage via socket. ---');
    ref.read(socketServiceProvider).sendMessage(messageData);

    _messageController.clear();
  }

  Future<void> _acceptRequest() async {
    setState(() {
      _isAccepting = true;
    });
    try {
      await _jobService.acceptJob(widget.job.id);
      log('Job ${widget.job.id} accepted');
      ref.refresh(providerScheduleProvider);
      Navigator.of(context).pop(true);
    } catch (e) {
      log('Error accepting job: $e');
    } finally {
       if (mounted) {
        setState(() {
          _isAccepting = false;
        });
      }
    }
  }

  Future<void> _declineRequest() async {
    setState(() {
      _isDeclining = true;
    });
    try {
      await _jobService.declineJob(widget.job.id);
      log('Job ${widget.job.id} declined');
      Navigator.of(context).pop(true);
    } catch (e) {
      log('Error declining job: $e');
    } finally {
       if (mounted) {
        setState(() {
          _isDeclining = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(userProvider).value;
    final theme = Theme.of(context);
    final bool isActionable = widget.job.status == 'PENDING';
    final bool isProcessing = _isAccepting || _isDeclining;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chatWith(widget.job.clientId?.firstName ?? l10n.client)),
        actions: [
          if (isActionable)
            Row(
              children: [
                TextButton(
                  onPressed: isProcessing ? null : _declineRequest,
                  child: _isDeclining
                      ? const CircularProgressIndicator()
                      : Text(l10n.decline, style: TextStyle(color: theme.colorScheme.error)),
                ),
                TextButton(
                  onPressed: isProcessing ? null : _acceptRequest,
                  child: _isAccepting
                      ? const CircularProgressIndicator()
                      : Text(l10n.accept),
                ),
              ],
            )
        ],
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
    final theme = Theme.of(context);
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
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
     final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.colorScheme.tertiary.withOpacity(0.5))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.typeMessage,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onSend,
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
