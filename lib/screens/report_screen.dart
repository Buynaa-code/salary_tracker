import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/transaction_provider.dart';
import '../utils/app_localization.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final report =
        context.watch<TransactionProvider>().generateEndOfMonthReport();
    final currencyFormat = NumberFormat.currency(
      symbol: '₮',
      decimalDigits: 0,
    );

    final totalIncome = report['totalIncome'] as double;
    final totalExpenses = report['totalExpenses'] as double;
    final netIncome = report['netIncome'] as double;
    final expensesByCategory =
        report['expensesByCategory'] as Map<String, double>;
    final recommendations = report['recommendations'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).monthlyReport),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(
              context,
              AppLocalizations.of(context).totalIncome,
              totalIncome,
              currencyFormat,
              Colors.green,
              Icons.arrow_upward,
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              context,
              AppLocalizations.of(context).totalExpenses,
              totalExpenses,
              currencyFormat,
              Colors.red,
              Icons.arrow_downward,
            ),
            const SizedBox(height: 16),
            _buildSummaryCard(
              context,
              AppLocalizations.of(context).netIncome,
              netIncome,
              currencyFormat,
              netIncome >= 0 ? Colors.blue : Colors.red,
              netIncome >= 0 ? Icons.account_balance : Icons.warning,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).expenseAnalysis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...expensesByCategory.entries.map((entry) {
              return _buildExpenseCategoryCard(
                context,
                entry.key,
                entry.value,
                currencyFormat,
              );
            }),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context).recommendations,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...recommendations.map((recommendation) {
              return _buildRecommendationCard(
                  context, recommendation as String);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    String title,
    double amount,
    NumberFormat currencyFormat,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currencyFormat.format(amount),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseCategoryCard(
    BuildContext context,
    String category,
    double amount,
    NumberFormat currencyFormat,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Text(
            _getCategoryEmoji(category),
            style: const TextStyle(fontSize: 24),
          ),
        ),
        title: Text(category),
        trailing: Text(
          currencyFormat.format(amount),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(BuildContext context, String recommendation) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          child: const Text(
            "💡",
            style: TextStyle(fontSize: 24),
          ),
        ),
        title: Text(recommendation),
      ),
    );
  }

  String _getCategoryEmoji(String category) {
    final Map<String, String> categoryEmojis = {
      'Food': '🍔',
      'Transportation': '🚗',
      'Entertainment': '🎮',
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

    return categoryEmojis[category] ?? '📋';
  }
}
