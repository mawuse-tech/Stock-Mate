class Sale {
  Sale(this.item, this.qty, this.total, this.date, this.method);

  final String item, method;
  final int qty;
  final double total;
  final DateTime date;
}
