class DashboardMetrics {
  final int totalEarnings;
  final double avgRating;

  DashboardMetrics({
    required this.totalEarnings,
    required this.avgRating,
  });

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalEarnings: json['totalEarnings'] ?? 0,
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
