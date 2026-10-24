import 'package:flutter/material.dart';
import '../../auth/data/auth_service.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/summary_card.dart';
import '../../../data/mock_data/mock_expenses.dart';
import '../../../data/mock_data/mock_inventory.dart';
import '../../../data/mock_data/mock_sales.dart';
import '../../../data/models/expense.dart';
import '../../../data/models/inventory_item.dart';
import '../../../data/models/sale.dart';
import '../../inventory/widgets/stock_status_badge.dart';
import '../../dashboard/widgets/dashboard_metric_card.dart';
import '../../inventory/screens/inventory_details_screen.dart';
import '../../inventory/screens/add_inventory_screen.dart';
import '../../sales/screens/sale_details_screen.dart';
import '../../sales/screens/add_sale_screen.dart';
import '../../expenses/screens/expense_details_screen.dart';
import '../../expenses/screens/add_expense_screen.dart';
import '../../sales/widgets/sale_list_item.dart';

part '../../../features/dashboard/screens/dashboard_view.dart';
part '../../../features/inventory/screens/inventory_view.dart';
part '../../../features/sales/screens/sales_view.dart';
part '../../../features/expenses/screens/expenses_view.dart';
part 'shell_forms.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.user, required this.onLogout});

  final AuthUser user;
  final VoidCallback onLogout;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int selectedTab = 0;
  String inventorySearch = '';
  String salesSearch = '';
  String stockFilter = 'All stock';

  // These lists are the single in-memory source of truth for every screen.
  final List<InventoryItem> items = List.of(mockInventory);
  final List<Sale> sales = List.of(mockSales);
  final List<Expense> expenses = List.of(mockExpenses);

  void updateState(VoidCallback callback) => setState(callback);

  List<Sale> get todaysSales =>
      sales.where((sale) => isToday(sale.date)).toList();
  List<Expense> get todaysExpenses =>
      expenses.where((expense) => isToday(expense.date)).toList();
  double get salesTotal =>
      todaysSales.fold(0, (total, sale) => total + sale.total);
  double get expenseTotal =>
      todaysExpenses.fold(0, (total, expense) => total + expense.amount);
  int get lowCount => items.where((item) => item.qty <= item.reorder).length;

  @override
  Widget build(BuildContext context) {
    final screens = [dashboard(), inventory(), salesPage(), expensesPage()];
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(index: selectedTab, children: screens),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) => setState(() => selectedTab = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFEAE5FF),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2_rounded),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Sales',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_outlined),
            selectedIcon: Icon(Icons.receipt),
            label: 'Expenses',
          ),
        ],
      ),
    );
  }
}
