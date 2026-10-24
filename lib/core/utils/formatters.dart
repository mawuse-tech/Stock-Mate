import '../constants/app_constants.dart';

String formatGhc(num value) =>
    '${AppConstants.currencySymbol} ${value.toStringAsFixed(2)}';

bool isToday(DateTime value) {
  final today = DateTime.now();
  return value.year == today.year &&
      value.month == today.month &&
      value.day == today.day;
}

String formatDate(DateTime value) =>
    '${value.day.toString().padLeft(2, '0')}/${value.month.toString().padLeft(2, '0')}/${value.year}';
