import 'package:mobile/features/bookings/domain/models/job.dart';

class ProviderEarnings {
  final Map<String, double> monthlyEarnings;
  final List<Job> recentTransactions;

  ProviderEarnings({
    required this.monthlyEarnings,
    required this.recentTransactions,
  });

  factory ProviderEarnings.fromJson(Map<String, dynamic> json) {
    return ProviderEarnings(
      monthlyEarnings: (json['monthlyEarnings'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, (value as num).toDouble()),
      ),
      recentTransactions: (json['recentTransactions'] as List)
          .map((job) => Job.fromJson(job))
          .toList(),
    );
  }
}
