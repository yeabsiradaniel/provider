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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.earnings),
      ),
      body: earningsAsyncValue.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },
        error: (err, stack) {
          return Center(child: Text('Error: $err'));
        },
        data: (earnings) {
          return RefreshIndicator(
            onRefresh: () => ref.refresh(providerEarningsProvider.future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.monthlyEarnings,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${earnings.monthlyEarnings.values.fold(0.0, (sum, item) => sum + item)} ETB',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          barGroups: earnings.monthlyEarnings.entries
                              .map((entry) => _buildBarGroup(
                                  _getMonthIndex(entry.key), entry.value))
                              .toList(),
                          titlesData: FlTitlesData(
                             bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(_getMonthName(value.toInt()));
                                    },
                                  ),
                                ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.recentTransactions,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: earnings.recentTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction =
                            earnings.recentTransactions[index];
                        return _buildTransactionItem(
                            transaction.serviceName,
                            '+ ${transaction.agreedPrice} ETB',
                            true);
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
    int _getMonthIndex(String month) {
    switch (month) {
      case 'Jan':
        return 0;
      case 'Feb':
        return 1;
      case 'Mar':
        return 2;
      case 'Apr':
        return 3;
      case 'May':
        return 4;
      case 'Jun':
        return 5;
      case 'Jul':
        return 6;
      case 'Aug':
        return 7;
      case 'Sep':
        return 8;
      case 'Oct':
        return 9;
      case 'Nov':
        return 10;
      case 'Dec':
        return 11;
      default:
        return 0;
    }
  }

  String _getMonthName(int index) {
    switch (index) {
      case 0:
        return 'Jan';
      case 1:
        return 'Feb';
      case 2:
        return 'Mar';
      case 3:
        return 'Apr';
      case 4:
        return 'May';
      case 5:
        return 'Jun';
      case 6:
        return 'Jul';
      case 7:
        return 'Aug';
      case 8:
        return 'Sep';
      case 9:
        return 'Oct';
      case 10:
        return 'Nov';
      case 11:
        return 'Dec';
      default:
        return '';
    }
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: Colors.blue,
          width: 22,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(6),
            topRight: Radius.circular(6),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(String title, String amount, bool isCredit) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          isCredit ? Icons.arrow_upward : Icons.arrow_downward,
          color: isCredit ? Colors.green : Colors.red,
        ),
        title: Text(title),
        trailing: Text(
          amount,
          style: TextStyle(
            color: isCredit ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
