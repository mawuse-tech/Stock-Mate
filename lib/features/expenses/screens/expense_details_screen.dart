import 'package:flutter/material.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/app_widgets.dart';
import '../../../core/widgets/detail_page.dart';
import '../../../data/models/expense.dart';

class ExpenseDetailsScreen extends StatelessWidget {
  const ExpenseDetailsScreen({super.key, required this.expense});

  final Expense expense;

  @override
  Widget build(BuildContext context) => DetailPage(
    title: 'Expense details',
    children: [
      HeroDetail(
        icon: Icons.receipt_outlined,
        title: expense.description.isEmpty
            ? expense.category
            : expense.description,
        subtitle: formatDate(expense.date),
        tag: expense.category,
      ),
      DetailLine('Category', expense.category),
      DetailLine('Amount', formatGhc(expense.amount)),
      if (expense.description.isNotEmpty)
        DetailLine('Description', expense.description),
    ],
  );
}
