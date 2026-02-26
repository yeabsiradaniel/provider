import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/services/socket_service.dart';
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
      // Handle or log error appropriately
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(userProvider).value;
    final theme = Theme.of(context);

    ref.listen<int>(newRequestNotifierProvider, (previous, next) {
      if (next > (previous ?? 0)) {
        _fetchIncomingJobs();
      }
    });

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    final profileAsyncValue = ref.watch(providerProfileProvider(user.id));

    return Scaffold(
      body: profileAsyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('${l10n.errorPrefix}$err')),
        data: (profile) {
          if (profile == null) {
            return Center(child: Text(l10n.providerProfileNotFound));
          }
          final bool isOnline = profile.isOnline;
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      l10n.providerDashboard,
                      style: theme.textTheme.labelSmall,
                    ),
                    Text(
                      '${user.firstName} ${user.lastName}',
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                actions: [
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
                    icon: const Icon(Icons.settings_outlined),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                       Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              icon: Icons.star_border,
                              title: l10n.avgRating,
                              value: profile.user.rating?.toStringAsFixed(1) ?? 'N/A',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StatCard(
                              icon: Icons.account_balance_wallet_outlined,
                              title: l10n.totalEarningsMonth,
                              value: '${profile.earnings} ETB',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _toggleStatus(isOnline),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isOnline ? theme.colorScheme.primary : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                             border: isOnline ? null : Border.all(color: theme.colorScheme.tertiary.withOpacity(0.5)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.power_settings_new, color: isOnline ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface),
                              const SizedBox(width: 8),
                              Text(
                                isOnline ? l10n.online.toUpperCase() : l10n.offline.toUpperCase(),
                                style: TextStyle(
                                  color: isOnline ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.incomingRequests,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                       if (_incomingJobs.isNotEmpty)
                          Container(
                             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            child: Text(_incomingJobs.length.toString(),
                                style: TextStyle(
                                    color: theme.colorScheme.onPrimary, fontWeight: FontWeight.bold)),
                          ),
                    ],
                  ),
                ),
              ),
              _isLoadingJobs
                ? const SliverToBoxAdapter(child: Center(child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                )))
                : _incomingJobs.isEmpty ? SliverToBoxAdapter(
                  child: Center(child: Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Text(l10n.noNewJobRequests, style: TextStyle(color: theme.colorScheme.secondary)),
                  )),
                )
                : SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                           final job = _incomingJobs[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: JobRequestCard(
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
                              ),
                            );
                        },
                        childCount: _incomingJobs.length,
                      ),
                    ),
                )
            ],
          );
        },
      ),
    );
  }
}
