import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../data/models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _description = TextEditingController();
  String _category = 'Supplies';
  DateTime _expenseDate = DateTime.now();

  @override
  void dispose() {
    _amount.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: true,
    appBar: AppBar(title: const Text('Add expense')),
    body: Form(
      key: _formKey,
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          AppTextField(
            label: 'Amount (GH₵)',
            controller: _amount,
            numeric: true,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(labelText: 'Category'),
            items:
                const [
                      'Transportation',
                      'Electricity',
                      'Supplies',
                      'Rent',
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
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: _selectDate,
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text('Date  ·  ${formatDate(_expenseDate)}'),
          ),
          const SizedBox(height: 10),
          AppTextField(
            label: 'Description (optional)',
            controller: _description,
            required: false,
          ),
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
            child: const Text('Save expense'),
          ),
        ),
      ),
    ),
  );

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _expenseDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (selected != null) setState(() => _expenseDate = selected);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Expense(
        double.parse(_amount.text),
        _category,
        _expenseDate,
        description: _description.text.trim(),
      ),
    );
  }
}
