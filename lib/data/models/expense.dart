class Expense {
  Expense(this.amount, this.category, this.date, {this.description = ''});

  final double amount;
  final String category;
  final DateTime date;
  final String description;
}
