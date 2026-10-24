import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../data/models/inventory_item.dart';
import '../../../data/models/sale.dart';

class AddSaleScreen extends StatefulWidget {
  const AddSaleScreen({super.key, required this.items});

  final List<InventoryItem> items;

  @override
  State<AddSaleScreen> createState() => _AddSaleScreenState();
}

class _AddSaleScreenState extends State<AddSaleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantity = TextEditingController(text: '1');
  late String _selectedName;
  String _paymentMethod = 'Cash';
  String? _error;

  InventoryItem get _selectedItem =>
      widget.items.firstWhere((item) => item.name == _selectedName);
  int get _quantityValue => int.tryParse(_quantity.text) ?? 0;

  @override
  void initState() {
    super.initState();
    _selectedName = widget.items.first.name;
  }

  @override
  void dispose() {
    _quantity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AppBar(title: const Text('Record a sale')),
    body: Form(
      key: _formKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedName,
            decoration: const InputDecoration(labelText: 'Inventory item'),
            items: widget.items
                .map(
                  (item) => DropdownMenuItem(
                    value: item.name,
                    child: Text(item.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedName = value;
                  _error = null;
                });
              }
            },
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _quantity,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Quantity (${_selectedItem.unit})',
            ),
            onChanged: (_) => setState(() => _error = null),
            validator: (value) {
              final amount = int.tryParse(value ?? '');
              if (amount == null || amount < 1) {
                return 'Enter a quantity greater than zero';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          Text(
            'Available: ${_selectedItem.qty} ${_selectedItem.unit}  ·  Unit price: ${formatGhc(_selectedItem.sellingPrice)}',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 10),
          Text(
            'Sale total  ${formatGhc(_selectedItem.sellingPrice * _quantityValue)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _paymentMethod,
            decoration: const InputDecoration(labelText: 'Payment method'),
            items: const ['Cash', 'Mobile Money', 'Card']
                .map(
                  (value) => DropdownMenuItem(value: value, child: Text(value)),
                )
                .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _paymentMethod = value);
            },
          ),
          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          height: 54,
          child: FilledButton(onPressed: _save, child: const Text('Save sale')),
        ),
      ),
    ),
  );

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final item = _selectedItem;
    final amount = int.parse(_quantity.text);
    if (amount > item.qty) {
      setState(() => _error = 'Only ${item.qty} ${item.unit} available.');
      return;
    }
    Navigator.pop(
      context,
      Sale(
        item.name,
        amount,
        item.sellingPrice * amount,
        DateTime.now(),
        _paymentMethod,
      ),
    );
  }
}
