part of '../../../features/shell/screens/main_shell.dart';

extension _DashboardView on _MainShellState {
  Widget dashboard() => ListView(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
    children: [
      Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: lavender,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.restaurant, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'YOUR BUSINESS TODAY',
                  style: TextStyle(fontSize: 11, letterSpacing: 1),
                ),
                Text(
                  widget.user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            tooltip: 'Account options',
            onSelected: (value) {
              if (value == 'logout') widget.onLogout();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: const Row(
                  children: [
                    Icon(Icons.logout, size: 19),
                    SizedBox(width: 10),
                    Text('Log out'),
                  ],
                ),
              ),
            ],
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.account_circle_outlined, color: ink, size: 27),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          Expanded(
            child: DashboardMetricCard(
              label: 'Today’s Sales',
              value: formatGhc(salesTotal),
              icon: Icons.receipt_long_outlined,
              color: const Color(0xFFEF5474),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DashboardMetricCard(
              label: 'Products',
              value: '${items.length}',
              icon: Icons.inventory_2_outlined,
              color: const Color(0xFFEF7893),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: DashboardMetricCard(
              label: 'Low Stock',
              value: '$lowCount',
              icon: Icons.warning_amber_rounded,
              color: const Color(0xFF818BD5),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DashboardMetricCard(
              label: 'Expenses',
              value: formatGhc(expenseTotal),
              icon: Icons.payments_outlined,
              color: const Color(0xFF5157CE),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      const Text(
        'Quick actions',
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(
            child: quickAction(
              'Add item',
              Icons.add_box_outlined,
              lavender,
              showStockForm,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: quickAction(
              'Record sale',
              Icons.add_shopping_cart,
              mint,
              showRecordSale,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: quickAction(
              'Add expense',
              Icons.receipt_outlined,
              coral,
              showExpenseForm,
            ),
          ),
        ],
      ),
      const SizedBox(height: 22),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Recent sales',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          TextButton(
            onPressed: () => updateState(() => selectedTab = 2),
            child: const Text('See all'),
          ),
        ],
      ),
      Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: todaysSales
                .take(3)
                .map(
                  (sale) => SaleListItem(
                    sale: sale,
                    onTap: () => openSaleDetails(sale),
                  ),
                )
                .toList(),
          ),
        ),
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Items to restock',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          TextButton(
            onPressed: () => updateState(() => selectedTab = 1),
            child: const Text('Inventory'),
          ),
        ],
      ),
      Card(
        child: Column(
          children: items
              .where((item) => item.qty <= item.reorder)
              .take(4)
              .map(
                (item) => ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFFF3E0),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      color: Color(0xFFE7B34C),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    item.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text('${item.qty} ${item.unit} remaining'),
                  trailing: StatusPill(item.status),
                  onTap: () => stockDetails(item),
                ),
              )
              .toList(),
        ),
      ),
      if (items.every((item) => item.qty > item.reorder))
        const EmptyState(
          title: 'Stock looks good',
          message: 'There are no items to restock today.',
          icon: Icons.check_circle_outline,
        ),
    ],
  );

  Widget quickAction(
    String label,
    IconData icon,
    Color color,
    VoidCallback action,
  ) => InkWell(
    onTap: action,
    borderRadius: BorderRadius.circular(18),
    child: Container(
      height: 78,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ),
  );
}
