import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('Main Menu'),
),
body: Padding(
padding: const EdgeInsets.all(20.0),
child: Column(
children: [
// 1. Total Balance Section
const Text(
'Total Balance',
style: TextStyle(fontSize: 20),
),
const Text(
'\$5,240.50',
style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
),
const SizedBox(height: 40),

// 2. Recent Transactions Header
const Align(
alignment: Alignment.centerLeft,
child: Text(
'Recent Transactions',
style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),
),
const SizedBox(height: 10),

// 3. Simple Hardcoded List
Expanded(
child: ListView(
children: const [
ListTile(
leading: Icon(Icons.shopping_cart),
title: Text('Groceries'),
trailing: Text('-\$45.00', style: TextStyle(color: Colors.red)),
),
ListTile(
leading: Icon(Icons.attach_money),
title: Text('Paycheck'),
trailing: Text('+\$2,000.00', style: TextStyle(color: Colors.green)),
),
ListTile(
leading: Icon(Icons.coffee),
title: Text('Coffee'),
trailing: Text('-\$4.50', style: TextStyle(color: Colors.red)),
),
ListTile(
leading: Icon(Icons.local_gas_station),
title: Text('Gas'),
trailing: Text('-\$35.00', style: TextStyle(color: Colors.red)),
),
ListTile(
leading: Icon(Icons.fastfood),
title: Text('Restaurant'),
trailing: Text('-\$62.30', style: TextStyle(color: Colors.red)),
),
ListTile(
leading: Icon(Icons.subscriptions),
title: Text('Streaming Service'),
trailing: Text('-\$15.99', style: TextStyle(color: Colors.red)),
),
ListTile(
leading: Icon(Icons.fitness_center),
title: Text('Gym Membership'),
trailing: Text('-\$50.00', style: TextStyle(color: Colors.red)),
),
ListTile(
leading: Icon(Icons.money),
title: Text('Venmo Transfer'),
trailing: Text('+\$25.00', style: TextStyle(color: Colors.green)),
),
ListTile(
leading: Icon(Icons.shopping_bag),
title: Text('Clothing'),
trailing: Text('-\$120.00', style: TextStyle(color: Colors.red)),
),
ListTile(
leading: Icon(Icons.electric_bolt),
title: Text('Electric Bill'),
trailing: Text('-\$85.00', style: TextStyle(color: Colors.red)),
),
ListTile(
leading: Icon(Icons.pets),
title: Text('Pet Food'),
trailing: Text('-\$40.00', style: TextStyle(color: Colors.red)),
),
ListTile(
leading: Icon(Icons.movie),
title: Text('Movie Tickets'),
trailing: Text('-\$30.00', style: TextStyle(color: Colors.red)),
),
],
),
),
],
),
),
);
}
}