import 'package:flutter/material.dart';
import 'package:mobile/features/provider_dashboard/presentation/screens/provider_dashboard_content.dart';
import 'package:mobile/features/provider_earnings/presentation/screens/provider_earnings_screen.dart';
import 'package:mobile/features/provider_profile/presentation/screens/provider_profile_screen.dart';
import 'package:mobile/features/provider_schedule/presentation/screens/provider_schedule_screen.dart';

class ProviderDashboardScreen extends StatefulWidget {
  const ProviderDashboardScreen({Key? key}) : super(key: key);

  @override
  _ProviderDashboardScreenState createState() =>
      _ProviderDashboardScreenState();
}

class _ProviderDashboardScreenState extends State<ProviderDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProviderDashboardContent(),
    const ProviderScheduleScreen(),
    const ProviderEarningsScreen(),
    const ProviderProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.dashboard,
                  color: _selectedIndex == 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor),
              onPressed: () => _onItemTapped(0),
            ),
            IconButton(
              icon: Icon(Icons.calendar_today,
                  color: _selectedIndex == 1
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor),
              onPressed: () => _onItemTapped(1),
            ),
            IconButton(
              icon: Icon(Icons.account_balance_wallet,
                  color: _selectedIndex == 2
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor),
              onPressed: () => _onItemTapped(2),
            ),
            IconButton(
              icon: Icon(Icons.person_outline,
                  color: _selectedIndex == 3
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).disabledColor),
              onPressed: () => _onItemTapped(3),
            ),
          ],
        ),
      ),
    );
  }
}
