// 5240.5 -> $5,240.50, -4.5 -> -$4.50
String formatMoney(double value) {
  final parts = value.abs().toStringAsFixed(2).split('.');
  // Puts a comma every three digits
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+$)'),
    (_) => ',',
  );
  final sign = value < 0 ? '-' : '';
  return '$sign\$$whole.${parts[1]}';
}

// Same thing but with a + for income
String formatSignedMoney(double value) {
  return value < 0 ? formatMoney(value) : '+${formatMoney(value)}';
}

// dd.MM.yyyy, no need for the intl package just for this
String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}
