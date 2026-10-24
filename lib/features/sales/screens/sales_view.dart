part of '../../../features/shell/screens/main_shell.dart';

extension _SalesView on _MainShellState {
  Widget salesPage() => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Sales',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ),
            FilledButton.icon(
              onPressed: showRecordSale,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Record sale'),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _salesSummary('Today', formatGhc(salesTotal)),
                _salesSummary('Sales', '${todaysSales.length}'),
                _salesSummary('All records', '${sales.length}'),
              ],
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
        child: TextField(
          decoration: const InputDecoration(
            hintText: 'Search sales',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => updateState(() => salesSearch = value),
        ),
      ),
      Expanded(
        child: sales.isEmpty
            ? const EmptyState(
                title: 'No sales yet',
                message: 'Record your first sale to see it here.',
                icon: Icons.receipt_long_outlined,
              )
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  ...sales
                      .where(
                        (sale) => sale.item.toLowerCase().contains(
                          salesSearch.toLowerCase(),
                        ),
                      )
                      .map(
                        (sale) => Card(
                          child: SaleListItem(
                            sale: sale,
                            onTap: () => openSaleDetails(sale),
                          ),
                        ),
                      ),
                ],
              ),
      ),
    ],
  );

  Widget _salesSummary(String label, String value) => Column(
    children: [
      Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
      ),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
    ],
  );

  void openSaleDetails(Sale sale) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => SaleDetailsScreen(sale: sale)),
  );
}
