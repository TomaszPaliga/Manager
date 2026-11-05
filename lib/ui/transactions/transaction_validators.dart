// Plain functions so they can be tested without building the form
const maxTitleLength = 40;
const maxAmount = 1000000.0;

// Digits with up to 2 decimals, dot or comma
final _amountPattern = RegExp(r'^\d+([.,]\d{1,2})?$');

String? validateTitle(String? value) {
  final title = value?.trim() ?? '';
  if (title.isEmpty) {
    return 'Enter a title';
  }
  if (title.length > maxTitleLength) {
    return 'Use at most $maxTitleLength characters';
  }
  return null;
}

String? validateAmount(String? value) {
  final text = value?.trim() ?? '';
  if (text.isEmpty) {
    return 'Enter an amount';
  }
  if (!_amountPattern.hasMatch(text)) {
    return 'Enter a number such as 12.50';
  }
  final amount = parseAmount(text);
  if (amount == null || amount <= 0) {
    return 'The amount must be greater than 0';
  }
  if (amount > maxAmount) {
    return 'The amount is too large';
  }
  return null;
}

// Polish keyboards give a comma, so accept both
double? parseAmount(String value) {
  return double.tryParse(value.trim().replaceAll(',', '.'));
}
