import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/bookings/domain/services/job_service.dart';
import 'package:mobile/features/chat/presentation/screens/chat_screen.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  final JobService _jobService = JobService();
  List<Job> _jobs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchJobs();
  }

  Future<void> _fetchJobs() async {
    try {
      // We can reuse the getBookingHistory since it returns all jobs for the client
      final jobs = await _jobService.getBookingHistory();
      // We only want to show chats for accepted or in-progress jobs
      final filteredJobs = jobs.where((job) => job.status == 'ACCEPTED' || job.status == 'ACTIVE').toList();
      setState(() {
        _jobs = filteredJobs;
        _isLoading = false;
      });
    } catch (e) {
       setState(() {
        _isLoading = false;
      });
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chat),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _jobs.isEmpty
              ? Center(child: Text("You have no active chats."))
              : ListView.builder(
                  itemCount: _jobs.length,
                  itemBuilder: (context, index) {
                    final job = _jobs[index];
                    return _buildChatItem(
                      context,
                      job: job
                    );
                  },
                ),
    );
  }

  Widget _buildChatItem(BuildContext context, {required Job job}) {
    return ListTile(
      // We need to fetch provider details to show their name and photo
      leading: const CircleAvatar(
        child: Icon(Icons.person),
      ),
      title: Text("Chat for: ${job.serviceName}"),
      subtitle: const Text("Click to view messages"), // This should be the last message
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              job: job,
            ),
          ),
        );
      },
    );
  }
}
