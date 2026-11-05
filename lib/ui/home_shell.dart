import 'package:flutter/material.dart';

import 'budgets/budgets_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'transactions/transactions_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  // Just which tab is open, so plain setState is fine here
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps the tabs alive, so the scroll position isn't lost
      body: IndexedStack(
        index: _index,
        children: const [
          DashboardScreen(),
          TransactionsScreen(),
          BudgetsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long),
            label: 'Transactions',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart),
            label: 'Budgets',
          ),
        ],
      ),
    );
  }
}
