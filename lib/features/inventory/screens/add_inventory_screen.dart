import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/inventory_item.dart';

/// Full-screen item form so the phone keyboard cannot cover the fields.
class AddInventoryScreen extends StatefulWidget {
  const AddInventoryScreen({super.key, this.item});

  final InventoryItem? item;

  @override
  State<AddInventoryScreen> createState() => _AddInventoryScreenState();
}

class _AddInventoryScreenState extends State<AddInventoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _quantity;
  late final TextEditingController _unit;
  late final TextEditingController _cost;
  late final TextEditingController _sellingPrice;
  late final TextEditingController _sku;
  late String _category;

  bool get _editing => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _name = TextEditingController(text: item?.name ?? '');
    _quantity = TextEditingController(text: item?.qty.toString() ?? '');
    _unit = TextEditingController(text: item?.unit ?? 'kg');
    _cost = TextEditingController(text: item?.cost.toString() ?? '');
    _sellingPrice = TextEditingController(
      text: item?.sellingPrice.toString() ?? '',
    );
    _sku = TextEditingController(text: item?.sku ?? '');
    _category = item?.category ?? 'Produce';
  }

  @override
  void dispose() {
    _name.dispose();
    _quantity.dispose();
    _unit.dispose();
    _cost.dispose();
    _sellingPrice.dispose();
    _sku.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    // Scaffold resizes its body and footer when the software keyboard opens.
    resizeToAvoidBottomInset: true,
    appBar: AppBar(
      title: Text(_editing ? 'Edit inventory item' : 'Add inventory item'),
    ),
    body: Form(
      key: _formKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(
            _editing ? 'Update item details' : 'Add an item to your stock',
            style: const TextStyle(
              color: ink,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 18),
          _field('Item name', _name),
          Row(
            children: [
              Expanded(child: _field('Quantity', _quantity, wholeNumber: true)),
              const SizedBox(width: 10),
              Expanded(child: _field('Unit (kg, L, pcs)', _unit)),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _field('Purchase cost (GH₵)', _cost, numeric: true),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _field(
                  'Selling price (GH₵)',
                  _sellingPrice,
                  numeric: true,
                ),
              ),
            ],
          ),
          _field('SKU (optional)', _sku, required: false),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items:
                const [
                      'Produce',
                      'Protein',
                      'Grains',
                      'Pantry',
                      'Drinks',
                      'Other',
                    ]
                    .map(
                      (value) =>
                          DropdownMenuItem(value: value, child: Text(value)),
                    )
                    .toList(),
            onChanged: (value) {
              if (value != null) setState(() => _category = value);
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),
    bottomNavigationBar: SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: SizedBox(
          height: 54,
          child: FilledButton(
            onPressed: _save,
            child: Text(_editing ? 'Save changes' : 'Save item'),
          ),
        ),
      ),
    ),
  );

  Widget _field(
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

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final oldItem = widget.item;
    final sku = _sku.text.trim();
    Navigator.pop(
      context,
      InventoryItem(
        _name.text.trim(),
        _category,
        int.parse(_quantity.text),
        _unit.text.trim(),
        double.parse(_cost.text),
        double.parse(_sellingPrice.text),
        oldItem?.reorder ?? 5,
        sku.isEmpty ? oldItem?.sku ?? '' : sku,
      ),
    );
  }
}
