/// Formats 5240.5 as `$5,240.50` and -4.5 as `-$4.50`.
String formatMoney(double value) {
  final parts = value.abs().toStringAsFixed(2).split('.');
  final whole = parts[0].replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+$)'),
    (_) => ',',
  );
  final sign = value < 0 ? '-' : '';
  return '$sign\$$whole.${parts[1]}';
}

/// Like [formatMoney], with a leading plus for income.
String formatSignedMoney(double value) {
  return value < 0 ? formatMoney(value) : '+${formatMoney(value)}';
}

/// Formats a date as dd.MM.yyyy.
String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}
