part of '../../../features/shell/screens/main_shell.dart';

extension _ExpensesView on _MainShellState {
  Widget expensesPage() => Column(
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
        child: Row(
          children: [
            const Expanded(
              child: Text(
                'Expenses',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ),
            FilledButton.icon(
              onPressed: showExpenseForm,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add expense'),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SummaryCard(
          label: 'Today’s expenses',
          value: formatGhc(expenseTotal),
          icon: Icons.receipt_outlined,
          color: coral,
        ),
      ),
      Expanded(
        child: expenses.isEmpty
            ? const EmptyState(
                title: 'No expenses yet',
                message: 'Add an expense to start tracking daily costs.',
                icon: Icons.receipt_outlined,
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                children: expenses
                    .map(
                      (expense) => Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Color(0xFFFFEEF2),
                            child: Icon(Icons.receipt, color: coral),
                          ),
                          title: Text(
                            expense.description.isEmpty
                                ? expense.category
                                : expense.description,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Text(
                            '${expense.category}  ·  ${formatDate(expense.date)}',
                          ),
                          trailing: Text(
                            formatGhc(expense.amount),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          onTap: () => openExpenseDetails(expense),
                        ),
                      ),
                    )
                    .toList(),
              ),
      ),
    ],
  );

  void openExpenseDetails(Expense expense) => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => ExpenseDetailsScreen(expense: expense)),
  );
}
