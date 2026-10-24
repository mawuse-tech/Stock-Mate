part of '../../../features/shell/screens/main_shell.dart';

extension _ShellForms on _MainShellState {
  Future<void> showRecordSale() async {
    if (items.isEmpty) {
      showSnack('Add an inventory item before recording a sale.');
      return;
    }
    final sale = await Navigator.push<Sale>(
      context,
      MaterialPageRoute(builder: (_) => AddSaleScreen(items: items)),
    );
    if (sale == null || !mounted) return;
    updateState(() {
      final item = items.firstWhere((item) => item.name == sale.item);
      item.qty -= sale.qty;
      sales.insert(0, sale);
    });
    showSnack('Sale recorded and stock updated.');
  }

  Future<void> showExpenseForm() async {
    final expense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(builder: (_) => const AddExpenseScreen()),
    );
    if (expense == null || !mounted) return;
    updateState(() => expenses.insert(0, expense));
    showSnack('Expense added.');
  }

  Future<void> showStockForm({InventoryItem? existing}) async {
    final updatedItem = await Navigator.push<InventoryItem>(
      context,
      MaterialPageRoute(builder: (_) => AddInventoryScreen(item: existing)),
    );
    if (updatedItem == null || !mounted) return;
    updateState(() {
      if (existing == null) {
        if (updatedItem.sku.isEmpty) {
          updatedItem.sku = 'ITEM-${items.length + 1}';
        }
        items.add(updatedItem);
      } else {
        // Keep the existing object so an open details screen sees the edits too.
        existing
          ..name = updatedItem.name
          ..category = updatedItem.category
          ..qty = updatedItem.qty
          ..unit = updatedItem.unit
          ..cost = updatedItem.cost
          ..sellingPrice = updatedItem.sellingPrice
          ..reorder = updatedItem.reorder
          ..sku = updatedItem.sku;
      }
    });
    showSnack(
      existing == null ? 'Inventory item added.' : 'Inventory item updated.',
    );
  }

  Future<void> showRestock(InventoryItem item) async {
    final quantity = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final amount = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Set ${item.name} quantity'),
        content: Form(
          key: formKey,
          child: field(
            'Current quantity (${item.unit})',
            quantity,
            wholeNumber: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.pop(dialogContext, int.parse(quantity.text));
            },
            child: const Text('Update stock'),
          ),
        ],
      ),
    );
    if (amount == null || !mounted) return;
    updateState(() => item.qty = amount);
    showSnack('Stock quantity updated.');
  }

  Widget field(
    String label,
    TextEditingController controller, {
    bool numeric = false,
    bool wholeNumber = false,
    bool required = true,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: AppTextField(
      label: label,
      controller: controller,
      numeric: numeric,
      wholeNumber: wholeNumber,
      required: required,
    ),
  );

  void showSnack(String message) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}
