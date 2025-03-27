import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../utils/transaction_provider.dart';
import '../utils/app_localization.dart';
import '../widgets/transaction_list_item.dart';
import '../widgets/summary_card.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final provider = Provider.of<TransactionProvider>(context);
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      symbol: '₮',
      decimalDigits: 0,
    );

    final totalIncome = provider.calculateTotalIncome();
    final totalExpenses = provider.calculateTotalExpenses();
    final balance = totalIncome - totalExpenses;
    final expensesByCategory = provider.calculateExpensesByCategory();
    final advice = provider.getFinancialAdvice();

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('appTitle')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              refreshKey.currentState?.show();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: () async {
          await provider.loadTransactions();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(context),
                const SizedBox(height: 24.0),
                _buildFinancialInsightsCarousel(context, provider,
                    currencyFormat, expensesByCategory, advice),
                const SizedBox(height: 24.0),
                _buildSummaryCards(context, provider),
                const SizedBox(height: 24.0),
                _buildFinancialAdvice(context, provider),
                const SizedBox(height: 24.0),
                _buildExpenseChart(context, provider),
                const SizedBox(height: 24.0),
                _buildRecentTransactions(context, provider),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final currentMonth = DateFormat.MMMM().format(now);
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 360;
    final appLocalizations = AppLocalizations.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF4D72FF),
              const Color(0xFF4D72FF).withOpacity(0.8),
            ],
          ),
        ),
        padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '👋 ${appLocalizations.translate('welcomeMessage', args: {
                              'name': 'Buynaa'
                            })}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 16 : 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '📊 ${appLocalizations.translate('monthlyFinance', args: {
                              'month': currentMonth
                            })}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: isSmallScreen ? 12 : 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: isSmallScreen ? 40 : 50,
                  height: isSmallScreen ? 40 : 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    color: Colors.white,
                    size: isSmallScreen ? 20 : 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(
      BuildContext context, TransactionProvider provider) {
    final appLocalizations = AppLocalizations.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    if (isSmallScreen) {
      // Stack cards vertically for small screens
      return Column(
        children: [
          SummaryCard(
            title: '💰 ${appLocalizations.translate('income')}',
            amount: provider.calculateTotalIncome(),
            icon: Icons.arrow_upward,
            color: Colors.green,
          ),
          const SizedBox(height: 12),
          SummaryCard(
            title: '💸 ${appLocalizations.translate('expense')}',
            amount: provider.calculateTotalExpenses(),
            icon: Icons.arrow_downward,
            color: Colors.red,
          ),
          const SizedBox(height: 12),
          SummaryCard(
            title: '💼 ${appLocalizations.translate('balance')}',
            amount: provider.calculateNetIncome(),
            icon: Icons.account_balance_wallet,
            color: const Color(0xFF4D72FF),
          ),
        ],
      );
    }

    // Use row layout for wider screens
    return Row(
      children: [
        Expanded(
          child: SummaryCard(
            title: '💰 ${appLocalizations.translate('income')}',
            amount: provider.calculateTotalIncome(),
            icon: Icons.arrow_upward,
            color: Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            title: '💸 ${appLocalizations.translate('expense')}',
            amount: provider.calculateTotalExpenses(),
            icon: Icons.arrow_downward,
            color: Colors.red,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SummaryCard(
            title: '💼 ${appLocalizations.translate('balance')}',
            amount: provider.calculateNetIncome(),
            icon: Icons.account_balance_wallet,
            color: const Color(0xFF4D72FF),
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialAdvice(
      BuildContext context, TransactionProvider provider) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final adviceList = provider.getFinancialAdvice();

    if (adviceList.isEmpty) {
      return Container();
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '💡',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  appLocalizations.translate('financialAdvice'),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...adviceList.map((advice) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('✅', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          advice,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseChart(
      BuildContext context, TransactionProvider provider) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final expensesByCategory = provider.calculateExpensesByCategory();
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    if (expensesByCategory.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '📊',
                  style: TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 16),
                Text(
                  appLocalizations.translate('noTransactions'),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Prepare data for pie chart
    List<PieChartSectionData> sections = [];
    final colors = [
      const Color(0xFF4D72FF),
      const Color(0xFFFF4D4D),
      const Color(0xFF4DFF72),
      const Color(0xFFFFD74D),
      const Color(0xFF9747FF),
      const Color(0xFF47DAFF),
      const Color(0xFFFF47B1),
      const Color(0xFF7EFF47),
      const Color(0xFFFF8847),
      const Color(0xFF47FFC2),
    ];

    int index = 0;
    Map<String, double> percentages = {};
    double totalExpense = provider.calculateTotalExpenses();

    expensesByCategory.forEach((category, amount) {
      double percentage = (amount / totalExpense) * 100;
      percentages[category] = percentage;

      sections.add(
        PieChartSectionData(
          color: colors[index % colors.length],
          value: amount,
          title: '',
          radius: 60,
          titleStyle: const TextStyle(
            fontSize: 0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      index++;
    });

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appLocalizations.translate('categories'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            if (isSmallScreen) ...[
              // Vertical layout for small screens
              SizedBox(
                height: 200,
                child: PieChart(
                  PieChartData(
                    sections: sections,
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                    startDegreeOffset: 180,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...expensesByCategory.entries.map((entry) {
                    final index =
                        expensesByCategory.keys.toList().indexOf(entry.key);
                    final color = colors[index % colors.length];
                    final percentage =
                        percentages[entry.key]?.toStringAsFixed(1) ?? '0.0';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              entry.key,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$percentage%',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ] else ...[
              // Horizontal layout for larger screens
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: sections,
                          sectionsSpace: 2,
                          centerSpaceRadius: 40,
                          startDegreeOffset: 180,
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...expensesByCategory.entries.map((entry) {
                            final index = expensesByCategory.keys
                                .toList()
                                .indexOf(entry.key);
                            final color = colors[index % colors.length];
                            final percentage =
                                percentages[entry.key]?.toStringAsFixed(1) ??
                                    '0.0';

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style:
                                          theme.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$percentage%',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFinancialInsightsCarousel(
      BuildContext context,
      TransactionProvider provider,
      NumberFormat currencyFormat,
      Map<String, double> expensesByCategory,
      List<String> advice) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final isSmallScreen = mediaQuery.size.width < 600;

    final items = <Widget>[
      // Savings Rate Card
      _buildInsightCard(
        context,
        title: '💰 ${AppLocalizations.of(context).translate('savingsRate')}',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).translate('yourCurrentSavingsRate'),
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: isSmallScreen ? 100 : 120,
                    height: isSmallScreen ? 100 : 120,
                    child: CircularProgressIndicator(
                      value: provider.calculateTotalIncome() > 0
                          ? ((provider.calculateTotalIncome() -
                                      provider.calculateTotalExpenses()) /
                                  provider.calculateTotalIncome())
                              .clamp(0.0, 1.0)
                          : 0.0,
                      strokeWidth: 12,
                      backgroundColor: theme.colorScheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          provider.calculateTotalIncome() > 0 &&
                                  (provider.calculateTotalIncome() -
                                              provider
                                                  .calculateTotalExpenses()) /
                                          provider.calculateTotalIncome() >=
                                      0.2
                              ? Colors.green
                              : theme.colorScheme.primary),
                    ),
                  ),
                  Text(
                    provider.calculateTotalIncome() > 0
                        ? '${((provider.calculateTotalIncome() - provider.calculateTotalExpenses()) / provider.calculateTotalIncome() * 100).toStringAsFixed(1)}%'
                        : '0%',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                AppLocalizations.of(context).translate('savingsRateGoal'),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        color: theme.colorScheme.primary.withOpacity(0.1),
        icon: Icons.savings,
      ),

      // Top Expense Category
      _buildInsightCard(
        context,
        title:
            '📊 ${AppLocalizations.of(context).translate('topExpenseCategory')}',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            if (expensesByCategory.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 48,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)
                          .translate('noExpensesRecorded'),
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .translate('highestSpendingCategory'),
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _getCategoryEmoji(expensesByCategory.entries
                                .reduce((a, b) => a.value > b.value ? a : b)
                                .key),
                            style: const TextStyle(fontSize: 36),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            expensesByCategory.entries
                                .reduce((a, b) => a.value > b.value ? a : b)
                                .key,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            currencyFormat.format(expensesByCategory.entries
                                .reduce((a, b) => a.value > b.value ? a : b)
                                .value),
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer
                                  .withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
        color: theme.colorScheme.secondaryContainer.withOpacity(0.5),
        icon: Icons.pie_chart,
      ),

      // Financial Tip
      _buildInsightCard(
        context,
        title: '💡 ${AppLocalizations.of(context).translate('financialTip')}',
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.tertiary.withOpacity(0.5),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      color: theme.colorScheme.tertiary,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      advice.isNotEmpty
                          ? advice.first
                          : AppLocalizations.of(context)
                              .translate('financialTipDefault'),
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        color: theme.colorScheme.tertiaryContainer.withOpacity(0.3),
        icon: Icons.lightbulb,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
          child: Text(
            '✨ ${AppLocalizations.of(context).translate('financialInsights')}',
            style: theme.textTheme.titleLarge,
          ),
        ),
        CarouselSlider(
          options: CarouselOptions(
            height: isSmallScreen ? 240 : 280,
            viewportFraction: isSmallScreen ? 0.9 : 0.88,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 6),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            scrollDirection: Axis.horizontal,
          ),
          items: items,
        ),
      ],
    );
  }

  Widget _buildInsightCard(
    BuildContext context, {
    required String title,
    required Widget content,
    required Color color,
    required IconData icon,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: theme.colorScheme.background,
                    child: Icon(icon, color: theme.colorScheme.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              content,
            ],
          ),
        ),
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

  Widget _buildRecentTransactions(
      BuildContext context, TransactionProvider provider) {
    final appLocalizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final transactions = provider.transactions;

    if (transactions.isEmpty) {
      return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '🧾',
                  style: TextStyle(fontSize: 48),
                ),
                const SizedBox(height: 16),
                Text(
                  appLocalizations.translate('noTransactions'),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Sort transactions by date, most recent first
    final sortedTransactions = List<Transaction>.from(transactions)
      ..sort((a, b) => b.date.compareTo(a.date));

    // Take only the last 5 transactions
    final recentTransactions = sortedTransactions.take(10).toList();

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🧾 ${appLocalizations.translate('today')}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to all transactions screen
                    // To be implemented
                  },
                  icon: const Icon(Icons.visibility, size: 16),
                  label: Text(appLocalizations.translate('viewAll')),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recentTransactions.map((transaction) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: TransactionListItem(
                    transaction: transaction,
                    onTap: () {
                      // Navigate to transaction detail screen
                      // To be implemented
                    },
                    onDelete: () {
                      // Show confirmation dialog and delete on confirm
                      _showDeleteConfirmationDialog(context, transaction);
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Transaction transaction) {
    final appLocalizations = AppLocalizations.of(context);
    final provider = Provider.of<TransactionProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(appLocalizations.translate('delete')),
        content: Text(
            '${appLocalizations.translate('deleteConfirmation')} ${transaction.description}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(appLocalizations.translate('cancel')),
          ),
          TextButton(
            onPressed: () {
              provider.deleteTransaction(transaction.id!);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text(appLocalizations.translate('transactionDeleted')),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text(
              appLocalizations.translate('delete'),
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
