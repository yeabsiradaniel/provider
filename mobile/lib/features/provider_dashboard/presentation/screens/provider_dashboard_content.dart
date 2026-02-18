import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/bookings/domain/models/job.dart';
import 'package:mobile/features/chat/presentation/screens/provider_chat_screen.dart';
import 'package:mobile/features/provider_dashboard/domain/services/dashboard_service.dart';
import 'package:mobile/features/provider_dashboard/presentation/screens/provider_settings_screen.dart';
import 'package:mobile/features/provider_dashboard/presentation/widgets/job_request_card.dart';
import 'package:mobile/features/provider_dashboard/presentation/widgets/stat_card.dart';
import 'package:mobile/features/provider_profile/domain/models/provider_profile.dart';
import 'package:mobile/features/provider_profile/domain/providers/provider_profile_provider.dart';
import 'package:mobile/features/user/domain/providers/user_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ProviderDashboardContent extends ConsumerStatefulWidget {
  const ProviderDashboardContent({Key? key}) : super(key: key);

  @override
  _ProviderDashboardContentState createState() =>
      _ProviderDashboardContentState();
}

class _ProviderDashboardContentState
    extends ConsumerState<ProviderDashboardContent> {
  final DashboardService _dashboardService = DashboardService();
  List<Job> _incomingJobs = [];
  bool _isLoadingJobs = true;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _fetchIncomingJobs();
  }

  Future<void> _fetchIncomingJobs() async {
    try {
      final jobs = await _dashboardService.getIncomingJobs();
      if (mounted) {
        setState(() {
          _incomingJobs = jobs;
          _isLoadingJobs = false;
        });
      }
    } catch (e) {
      log('Error fetching incoming jobs: $e');
      if (mounted) {
        setState(() {
          _isLoadingJobs = false;
        });
      }
    }
  }

  Future<void> _toggleStatus(bool currentStatus) async {
    final newStatus = !currentStatus;
    try {
      final user = ref.read(userProvider).value;
      if (user == null) return;
      final ProviderProfile updatedProfile = await _dashboardService.toggleStatus(newStatus);
      ref.read(providerProfileProvider(user.id).notifier).updateProviderProfile(updatedProfile);
    } catch (e) {
      log('Error toggling status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider).value;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final profileAsyncValue = ref.watch(providerProfileProvider(user.id));

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: profileAsyncValue.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
          data: (profile) {
            if (profile == null) {
              return const Center(child: Text('Provider profile not found.'));
            }
            final bool isOnline = profile.isOnline;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1E293B),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${user.firstName} ${user.lastName}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(color: Colors.white),
                                ),
                                Text(
                                  l10n.providerDashboard,
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 12),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ProviderSettingsScreen(),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.settings,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(
                          l10n.totalEarningsMonth,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          '${profile.earnings} ETB',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: StatCard(
                              title: l10n.avgRating,
                              value: profile.user.rating?.toStringAsFixed(1) ?? '0.0',
                              color: Colors.green),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTapDown: (_) => setState(() => _isTapped = true),
                            onTapUp: (_) {
                              setState(() => _isTapped = false);
                              _toggleStatus(isOnline);
                            },
                            onTapCancel: () => setState(() => _isTapped = false),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              transform: Matrix4.identity()
                                ..scale(_isTapped ? 0.95 : 1.0),
                              child: StatCard(
                                title: l10n.status,
                                value: isOnline ? l10n.online : l10n.offline,
                                color: isOnline ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.incomingRequests,
                              style:
                                  Theme.of(context).textTheme.titleLarge,
                            ),
                            if (_incomingJobs.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(_incomingJobs.length.toString(),
                                    style: const TextStyle(
                                        color: Colors.white)),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _isLoadingJobs
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _incomingJobs.length,
                                itemBuilder: (context, index) {
                                  final job = _incomingJobs[index];
                                  return JobRequestCard(
                                    initials: '${job.clientId?.firstName.substring(0, 1) ?? '?'}${job.clientId?.lastName.substring(0, 1) ?? ''}',
                                    name: '${job.clientId?.firstName ?? 'Unknown'} ${job.clientId?.lastName ?? 'Client'}',
                                    details: job.serviceName,
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProviderChatScreen(job: job),
                                        ),
                                      );
                                      if (result == true) {
                                        _fetchIncomingJobs();
                                      }
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 16),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
