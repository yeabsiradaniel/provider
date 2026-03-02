import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobile/features/provider_earnings/domain/providers/provider_earnings_provider.dart';
import 'package:mobile/l10n/app_localizations.dart';

class ProviderEarningsScreen extends ConsumerWidget {
  const ProviderEarningsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final earningsAsyncValue = ref.watch(providerEarningsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: earningsAsyncValue.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (err, stack) {
          return Center(child: Text('${l10n.errorPrefix}$err'));
        },
        data: (earnings) {
          final totalEarnings = earnings.monthlyEarnings.values.fold(0.0, (sum, item) => sum + item);
          return RefreshIndicator(
            onRefresh: () => ref.refresh(providerEarningsProvider.future),
            child: CustomScrollView(
              slivers: [
                 SliverAppBar(
                  title: Text(l10n.earnings),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.totalEarningsMonth,
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$totalEarnings ETB',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimary,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                         SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                               barTouchData: BarTouchData(enabled: false),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        _getMonthName(value.toInt()),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                    reservedSize: 30,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, meta) {
                                      if (value == meta.max || value == meta.min) return Container();
                                      return Text(
                                        value.toInt().toString(),
                                        style: TextStyle(
                                           color: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.color,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(
                                    sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: FlGridData(
                                show: true,
                                drawHorizontalLine: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.1),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              barGroups: earnings.monthlyEarnings.entries
                                  .map((entry) => _buildBarGroup(
                                      _getMonthIndex(entry.key), entry.value, theme))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                 SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Text(
                        l10n.recentTransactions,
                        style: theme.textTheme.titleLarge
                      ),
                  ),
                 ),
                 SliverPadding(
                   padding: const EdgeInsets.symmetric(horizontal: 16),
                   sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                       (context, index) {
                        final transaction = earnings.recentTransactions[index];
                        return _buildTransactionItem(
                            transaction.serviceName,
                            '+ ${transaction.agreedPrice} ETB',
                            true,
                            theme);
                      },
                      childCount: earnings.recentTransactions.length,
                    ),
                   ),
                 )
              ],
            ),
          );
        },
      ),
    );
  }

  int _getMonthIndex(String month) {
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'].indexOf(month);
  }

  String _getMonthName(int index) {
    if (index < 0 || index > 11) return '';
    return ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][index];
  }

  BarChartGroupData _buildBarGroup(int x, double y, ThemeData theme) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: theme.colorScheme.primary,
          width: 22,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(String title, String amount, bool isCredit, ThemeData theme) {
    final color = isCredit ? theme.colorScheme.primary : theme.colorScheme.error;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.tertiary.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(8)
            ),
            child: Icon(
              isCredit ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
              color: color,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500))),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
