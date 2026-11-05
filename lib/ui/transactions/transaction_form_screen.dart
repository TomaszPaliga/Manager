import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/models/transaction.dart';
import '../core/formatters.dart';
import 'transaction_validators.dart';
import 'transactions_view_model.dart';

// Same screen for adding and editing, transactionId is null when adding
class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key, this.transactionId});

  final String? transactionId;

  static Route<void> route({String? transactionId}) {
    return MaterialPageRoute<void>(
      builder: (_) => TransactionFormScreen(transactionId: transactionId),
    );
  }

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  // Local form state, setState is fine because it's not app data
  Transaction? _existing;
  TransactionType _type = TransactionType.expense;
  TransactionCategory _category = TransactionCategory.other;
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final id = widget.transactionId;
    if (id == null) {
      return;
    }
    // Editing, so fill in the form with the current values
    final existing = context.read<TransactionsViewModel>().transactionById(id);
    if (existing != null) {
      _existing = existing;
      _titleController.text = existing.title;
      _amountController.text = existing.amount.toStringAsFixed(2);
      _noteController.text = existing.note ?? '';
      _type = existing.type;
      _category = existing.category;
      _date = existing.date;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() => _date = picked);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Same as in details, get these before the await
    final vm = context.read<TransactionsViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final existing = _existing;
    final note = _noteController.text.trim();
    final transaction = Transaction(
      // Empty id for a new one, the repository sets it
      id: existing?.id ?? '',
      title: _titleController.text.trim(),
      amount: parseAmount(_amountController.text)!,
      type: _type,
      category: _category,
      date: _date,
      note: note.isEmpty ? null : note,
    );

    setState(() => _saving = true);
    final saved = existing == null
        ? await vm.add(transaction)
        : await vm.update(transaction);
    // The user could have left the screen while this was saving
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);

    if (saved) {
      navigator.pop();
    } else {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not save. Try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit transaction' : 'New transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                validator: validateTitle,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.next,
                validator: validateAmount,
              ),
              const SizedBox(height: 16),
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text('Expense'),
                  ),
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text('Income'),
                  ),
                ],
                selected: {_type},
                onSelectionChanged: (selection) {
                  setState(() => _type = selection.first);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TransactionCategory>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: [
                  for (final category in TransactionCategory.values)
                    DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                ],
                onChanged: (category) {
                  if (category != null) {
                    setState(() => _category = category);
                  }
                },
              ),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_today),
                title: const Text('Date'),
                subtitle: Text(formatDate(_date)),
                onTap: _pickDate,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
