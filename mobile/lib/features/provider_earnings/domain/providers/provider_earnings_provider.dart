import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/provider_earnings/domain/models/provider_earnings.dart';
import 'package:mobile/features/provider_earnings/domain/services/provider_earnings_service.dart';

final providerEarningsServiceProvider = Provider((ref) => ProviderEarningsService());

final providerEarningsProvider = FutureProvider<ProviderEarnings>((ref) async {
  final earningsService = ref.watch(providerEarningsServiceProvider);
  return earningsService.getEarnings();
});
