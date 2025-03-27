import 'package:flutter/foundation.dart';
import '../models/transaction.dart';
import '../models/category.dart' as app_models;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TransactionProvider extends ChangeNotifier {
  List<Transaction> _transactions = [];
  List<app_models.Category> _categories = [];

  // Getters
  List<Transaction> get transactions => _transactions;
  List<app_models.Category> get categories => [
        ...app_models.Category.expenseCategories,
        ...app_models.Category.incomeCategories
      ];

  TransactionProvider() {
    _loadSampleData();
  }

  // Initialize data
  Future<void> loadData() async {
    _loadSampleData();
    notifyListeners();
  }

  // Load sample data for demonstration
  void _loadSampleData() {
    final now = DateTime.now();
    final salary = 800000.0;

    // Add salary transactions
    _transactions.addAll([
      Transaction(
        id: '1',
        description: 'Monthly Salary',
        amount: salary,
        date: DateTime(now.year, now.month, 10),
        category: 'Salary',
        type: TransactionType.income,
      ),
      Transaction(
        id: '2',
        description: 'Monthly Salary',
        amount: salary,
        date: DateTime(now.year, now.month, 25),
        category: 'Salary',
        type: TransactionType.income,
      ),
    ]);

    // Add sample expenses
    _transactions.addAll([
      Transaction(
        id: '3',
        description: 'Grocery Shopping',
        amount: 150000,
        date: DateTime(now.year, now.month, 5),
        category: 'Food',
        type: TransactionType.expense,
      ),
      Transaction(
        id: '4',
        description: 'Bus Ticket',
        amount: 5000,
        date: DateTime(now.year, now.month, 7),
        category: 'Transportation',
        type: TransactionType.expense,
      ),
    ]);
  }

  // Load all transactions (in this case, just notify listeners)
  Future<void> loadTransactions() async {
    notifyListeners();
  }

  // Load all categories (in this case, just notify listeners)
  Future<void> loadCategories() async {
    notifyListeners();
  }

  // Add a new transaction
  void addTransaction(Transaction transaction) {
    _transactions.add(transaction);
    notifyListeners();
  }

  // Update an existing transaction
  Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index != -1) {
      _transactions[index] = transaction;
      notifyListeners();
    }
  }

  // Delete a transaction
  void deleteTransaction(String id) {
    _transactions.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  // Add a new category
  Future<void> addCategory(app_models.Category category) async {
    // No-op, using predefined categories
    notifyListeners();
  }

  // Update an existing category
  Future<void> updateCategory(app_models.Category category) async {
    // No-op, using predefined categories
    notifyListeners();
  }

  // Delete a category
  Future<void> deleteCategory(String name) async {
    // No-op, using predefined categories
    notifyListeners();
  }

  // Get transactions by date
  Future<List<Transaction>> getTransactionsByDate(DateTime date) async {
    return _transactions.where((transaction) {
      return transaction.date.year == date.year &&
          transaction.date.month == date.month &&
          transaction.date.day == date.day;
    }).toList();
  }

  // Get transactions by month
  Future<List<Transaction>> getTransactionsByMonth(int year, int month) async {
    return _transactions.where((transaction) {
      return transaction.date.year == year && transaction.date.month == month;
    }).toList();
  }

  // Get transactions by type
  Future<List<Transaction>> getTransactionsByType(TransactionType type) async {
    return _transactions
        .where((transaction) => transaction.type == type)
        .toList();
  }

  // Calculate total income
  double calculateTotalIncome() {
    return _transactions
        .where((transaction) => transaction.type == TransactionType.income)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  // Calculate total expenses
  double calculateTotalExpenses() {
    return _transactions
        .where((transaction) => transaction.type == TransactionType.expense)
        .fold(0, (sum, transaction) => sum + transaction.amount);
  }

  // Calculate net income (income - expenses)
  double calculateNetIncome() {
    return calculateTotalIncome() - calculateTotalExpenses();
  }

  // Calculate expenses by category
  Map<String, double> calculateExpensesByCategory() {
    final Map<String, double> result = {};

    for (var transaction in _transactions) {
      if (transaction.type == TransactionType.expense) {
        if (result.containsKey(transaction.category)) {
          result[transaction.category] =
              result[transaction.category]! + transaction.amount;
        } else {
          result[transaction.category] = transaction.amount;
        }
      }
    }

    return result;
  }

  // Analyze spending patterns and provide financial advice
  List<String> getFinancialAdvice() {
    final List<String> advice = [];
    final Map<String, double> expensesByCategory =
        calculateExpensesByCategory();
    final double totalExpenses = calculateTotalExpenses();

    // If no expenses, return empty advice
    if (totalExpenses == 0) return advice;

    // Check if any category exceeds 30% of total expenses
    expensesByCategory.forEach((category, amount) {
      double percentage = (amount / totalExpenses) * 100;
      if (percentage > 30) {
        advice.add(
            'You are spending too much on $category (${percentage.toStringAsFixed(1)}% of expenses)');
      }
    });

    // Check overall financial health
    double incomeToExpenseRatio =
        calculateTotalIncome() > 0 ? calculateTotalIncome() / totalExpenses : 0;

    if (incomeToExpenseRatio > 0 && incomeToExpenseRatio < 1.1) {
      advice.add(
          'Your expenses are close to your income. Consider reducing expenses.');
    }

    return advice;
  }

  Map<String, dynamic> generateEndOfMonthReport() {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month, 1);
    final nextMonth = DateTime(now.year, now.month + 1, 1);

    final monthlyTransactions = _transactions
        .where(
            (t) => t.date.isAfter(currentMonth) && t.date.isBefore(nextMonth))
        .toList();

    final totalIncome = monthlyTransactions
        .where((t) => t.type == TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpenses = monthlyTransactions
        .where((t) => t.type == TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);

    final netIncome = totalIncome - totalExpenses;

    final expensesByCategory = <String, double>{};
    for (var transaction in monthlyTransactions
        .where((t) => t.type == TransactionType.expense)) {
      expensesByCategory[transaction.category] =
          (expensesByCategory[transaction.category] ?? 0) + transaction.amount;
    }

    final recommendations = <String>[];
    if (netIncome < 0) {
      recommendations.add(
          'Your expenses exceed your income. Consider reducing discretionary spending.');
    }
    if (totalExpenses > totalIncome * 0.8) {
      recommendations.add(
          'You are spending more than 80% of your income. Try to increase your savings rate.');
    }
    if (expensesByCategory['Food'] != null &&
        expensesByCategory['Food']! > totalExpenses * 0.3) {
      recommendations.add(
          'Food expenses are high. Consider meal planning and cooking at home.');
    }
    if (expensesByCategory['Entertainment'] != null &&
        expensesByCategory['Entertainment']! > totalExpenses * 0.2) {
      recommendations.add(
          'Entertainment expenses are high. Look for free or low-cost activities.');
    }

    return {
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'netIncome': netIncome,
      'expensesByCategory': expensesByCategory,
      'recommendations': recommendations,
    };
  }
}
