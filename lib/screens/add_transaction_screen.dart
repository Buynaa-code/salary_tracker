import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../utils/transaction_provider.dart';
import '../utils/app_localization.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionType type;

  const AddTransactionScreen({
    Key? key,
    required this.type,
  }) : super(key: key);

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  late DateTime _selectedDate;
  String? _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final description = _descriptionController.text;
      final amount = double.parse(_amountController.text);
      final transaction = Transaction(
        description: description,
        amount: amount,
        date: _selectedDate,
        category: _selectedCategory ?? 'Other',
        type: widget.type,
      );

      // Add the transaction
      Provider.of<TransactionProvider>(context, listen: false)
          .addTransaction(transaction);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.type == TransactionType.income
              ? 'Income added successfully'
              : 'Expense added successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final provider = Provider.of<TransactionProvider>(context);
    final categories = provider.categories;
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;
    final padding = mediaQuery.size.width * 0.05;

    final title = widget.type == TransactionType.income
        ? '${appLocalizations.translate('addIncome')} 💰'
        : '${appLocalizations.translate('addExpense')} 💸';

    final color =
        widget.type == TransactionType.income ? Colors.green : Colors.red;

    // Define emojis for categories
    final Map<String, String> categoryEmojis = {
      'Food': '🍔',
      'Transportation': '🚗',
      'Entertainment': '🎬',
      'Shopping': '🛍️',
      'Utilities': '💡',
      'Housing': '🏠',
      'Healthcare': '🏥',
      'Education': '📚',
      'Salary': '💵',
      'Freelance': '💻',
      'Investment': '📈',
      'Gifts': '🎁',
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: color,
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding:
                    EdgeInsets.symmetric(horizontal: padding, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Description field
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText:
                                      '✏️ ${appLocalizations.translate('description')}',
                                  prefixIcon: const Icon(Icons.description),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return appLocalizations
                                        .translate('pleaseEnterDescription');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Amount field
                              TextFormField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText:
                                      '💲 ${appLocalizations.translate('amount')}',
                                  prefixIcon: const Icon(Icons.attach_money),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return appLocalizations
                                        .translate('pleaseEnterAmount');
                                  }
                                  try {
                                    double.parse(value.replaceAll(',', ''));
                                  } catch (e) {
                                    return appLocalizations
                                        .translate('pleaseEnterValidAmount');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),

                              // Date picker
                              InkWell(
                                onTap: () => _selectDate(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Text('📅',
                                          style: TextStyle(fontSize: 18)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          DateFormat.yMMMd()
                                              .format(_selectedDate),
                                          style: theme.textTheme.bodyLarge,
                                        ),
                                      ),
                                      const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Category dropdown
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey.shade300,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButtonFormField<String>(
                                    isExpanded: true,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      prefixIcon: Text('🔖',
                                          style: TextStyle(fontSize: 18)),
                                    ),
                                    hint: Text(
                                      '${appLocalizations.translate('category')}',
                                    ),
                                    value: _selectedCategory,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return appLocalizations
                                            .translate('pleaseSelectCategory');
                                      }
                                      return null;
                                    },
                                    items: categories
                                        .map((category) => DropdownMenuItem(
                                              value: category.name,
                                              child: Row(
                                                children: [
                                                  Text(categoryEmojis[
                                                          category.name] ??
                                                      '📋'),
                                                  const SizedBox(width: 8),
                                                  Text(category.name),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCategory = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Submit button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _submitForm,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: color,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Text(
                                    '💾 ${appLocalizations.translate('save')}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
