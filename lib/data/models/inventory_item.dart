class InventoryItem {
  InventoryItem(
    this.name,
    this.category,
    this.qty,
    this.unit,
    this.cost,
    this.sellingPrice,
    this.reorder,
    this.sku,
  );

  String name, category, unit, sku;
  int qty, reorder;
  double cost;
  double sellingPrice;

  String get status => qty == 0
      ? 'Out of stock'
      : qty <= reorder
      ? 'Low stock'
      : 'In stock';
}
