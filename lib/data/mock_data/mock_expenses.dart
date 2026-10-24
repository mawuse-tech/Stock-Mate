import '../models/expense.dart';

final mockExpenses = <Expense>[
  Expense(425, 'Supplies', DateTime.now(), description: 'Market produce run'),
  Expense(
    180,
    'Electricity',
    DateTime.now(),
    description: 'Daily meter top-up',
  ),
  Expense(90, 'Transportation', DateTime.now(), description: 'Delivery fuel'),
];
