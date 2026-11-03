import 'package:flutter/material.dart';

import '../../../domain/models/transaction.dart';
import '../category_icons.dart';
import '../formatters.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction, this.onTap});

  final Transaction transaction;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    return ListTile(
      leading: Icon(transaction.category.icon),
      title: Text(transaction.title),
      subtitle: Text(formatDate(transaction.date)),
      trailing: Text(
        formatSignedMoney(transaction.signedAmount),
        style: TextStyle(color: isIncome ? Colors.green : Colors.red),
      ),
      onTap: onTap,
    );
  }
}
