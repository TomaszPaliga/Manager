import 'package:flutter/material.dart';

import '../../domain/models/transaction.dart';

// Icons live here and not in the enum so domain doesn't depend on Flutter
extension CategoryIcon on TransactionCategory {
  IconData get icon => switch (this) {
    TransactionCategory.salary => Icons.attach_money,
    TransactionCategory.groceries => Icons.shopping_cart,
    TransactionCategory.eatingOut => Icons.fastfood,
    TransactionCategory.transport => Icons.local_gas_station,
    TransactionCategory.subscriptions => Icons.subscriptions,
    TransactionCategory.health => Icons.fitness_center,
    TransactionCategory.shopping => Icons.shopping_bag,
    TransactionCategory.bills => Icons.electric_bolt,
    TransactionCategory.pets => Icons.pets,
    TransactionCategory.entertainment => Icons.movie,
    TransactionCategory.other => Icons.category,
  };
}
