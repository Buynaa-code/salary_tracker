import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Salary Tracker',
      'income': 'Income',
      'expense': 'Expense',
      'salary': 'Salary',
      'dailySalary': 'Daily Salary',
      'netSalary': 'Net Salary',
      'taxes': 'Taxes',
      'date': 'Date',
      'category': 'Category',
      'amount': 'Amount',
      'description': 'Description',
      'save': 'Save',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'edit': 'Edit',
      'addIncome': 'Add Income',
      'addExpense': 'Add Expense',
      'categories': 'Categories',
      'addCategory': 'Add Category',
      'settings': 'Settings',
      'language': 'Language',
      'english': 'English',
      'mongolian': 'Mongolian',
      'theme': 'Theme',
      'darkMode': 'Dark Mode',
      'lightMode': 'Light Mode',
      'systemDefault': 'System Default',
      'notifications': 'Notifications',
      'dailyReminder': 'Daily Reminder',
      'statistics': 'Statistics',
      'report': 'Report',
      'monthlyReport': 'Monthly Report',
      'financialAdvice': 'Financial Advice',
      'noTransactions': 'No transactions found',
      'total': 'Total',
      'balance': 'Balance',
      'today': 'Today',
      'thisWeek': 'This Week',
      'thisMonth': 'This Month',
      'selectDate': 'Select Date',
      'selectCategory': 'Select Category',
      'taxInfo': 'Tax Info',
      'taxRate': 'Tax Rate',
      'home': 'Home',
      'calendar': 'Calendar',
      'reports': 'Reports',
      'profile': 'Profile',
      'close': 'Close',
      'viewAll': 'View All',
      'pleaseEnterDescription': 'Please enter a description',
      'pleaseEnterAmount': 'Please enter an amount',
      'pleaseEnterValidAmount': 'Please enter a valid amount',
      'pleaseSelectCategory': 'Please select a category',
      'income': 'Income',
      'expense': 'Expense',
      'balance': 'Balance',
      'categories': 'Categories',
      'today': 'Recent Transactions',
      'viewAll': 'See All',
      'delete': 'Delete',
      'deleteConfirmation': 'Are you sure you want to delete',
      'transactionDeleted': 'Transaction deleted',
      'cancel': 'Cancel',
      'noTransactions': 'No transactions yet',
      'financialAdvice': 'Financial Tips',
      'welcomeMessage': 'Welcome, {name}!',
      'monthlyFinance': '{month} Financial Summary',
      'addIncome': 'Add Income',
      'addExpense': 'Add Expense',
      'pleaseEnterDescription': 'Please enter a description',
      'pleaseEnterAmount': 'Please enter an amount',
      'pleaseEnterValidAmount': 'Please enter a valid amount',
      'pleaseSelectCategory': 'Please select a category',
      'totalIncome': 'Total Income',
      'totalExpenses': 'Total Expenses',
      'netIncome': 'Net Income',
      'expenseAnalysis': 'Expense Analysis',
      'recommendations': 'Recommendations',
      'savingsRate': 'Savings Rate',
      'yourCurrentSavingsRate': 'Your current savings rate:',
      'savingsRateGoal': 'Aim for at least 20% to build financial security',
      'topExpenseCategory': 'Top Expense Category',
      'noExpensesRecorded': 'No expenses recorded yet',
      'highestSpendingCategory': 'Your highest spending category:',
      'financialTip': 'Financial Tip',
      'financialTipDefault':
          'Try the 50/30/20 rule: 50% needs, 30% wants, 20% savings',
      'financialInsights': 'Financial Insights',
    },
    'mn': {
      'appTitle': 'Цалингийн Бүртгэл',
      'income': 'Орлого',
      'expense': 'Зарлага',
      'salary': 'Цалин',
      'dailySalary': 'Өдрийн цалин',
      'netSalary': 'Цэвэр цалин',
      'taxes': 'Татвар',
      'date': 'Огноо',
      'category': 'Ангилал',
      'amount': 'Дүн',
      'description': 'Тайлбар',
      'save': 'Хадгалах',
      'cancel': 'Цуцлах',
      'delete': 'Устгах',
      'edit': 'Засах',
      'addIncome': 'Орлого нэмэх',
      'addExpense': 'Зарлага нэмэх',
      'categories': 'Ангилалууд',
      'addCategory': 'Ангилал нэмэх',
      'settings': 'Тохиргоо',
      'language': 'Хэл',
      'english': 'Англи',
      'mongolian': 'Монгол',
      'theme': 'Загвар',
      'darkMode': 'Харанхуй горим',
      'lightMode': 'Цайвар горим',
      'systemDefault': 'Системийн горим',
      'notifications': 'Мэдэгдэл',
      'dailyReminder': 'Өдөр тутмын сануулга',
      'statistics': 'Статистик',
      'report': 'Тайлан',
      'monthlyReport': 'Сарын тайлан',
      'financialAdvice': 'Санхүүгийн зөвлөгөө',
      'noTransactions': 'Гүйлгээ олдсонгүй',
      'total': 'Нийт',
      'balance': 'Үлдэгдэл',
      'today': 'Өнөөдөр',
      'thisWeek': 'Энэ долоо хоног',
      'thisMonth': 'Энэ сар',
      'selectDate': 'Огноо сонгох',
      'selectCategory': 'Ангилал сонгох',
      'taxInfo': 'Татварын мэдээлэл',
      'taxRate': 'Татварын хувь',
      'home': 'Нүүр',
      'calendar': 'Хуанли',
      'reports': 'Тайлан',
      'profile': 'Хэрэглэгч',
      'close': 'Хаах',
      'viewAll': 'Бүгдийг харах',
      'pleaseEnterDescription': 'Тайлбар оруулна уу',
      'pleaseEnterAmount': 'Мөнгөн дүн оруулна уу',
      'pleaseEnterValidAmount': 'Зөв мөнгөн дүн оруулна уу',
      'pleaseSelectCategory': 'Ангилал сонгоно уу',
      'income': 'Орлого',
      'expense': 'Зарлага',
      'balance': 'Үлдэгдэл',
      'categories': 'Ангилалууд',
      'today': 'Сүүлийн гүйлгээнүүд',
      'viewAll': 'Бүгдийг харах',
      'delete': 'Устгах',
      'deleteConfirmation': 'Та устгахдаа итгэлтэй байна уу',
      'transactionDeleted': 'Гүйлгээ устгагдлаа',
      'cancel': 'Цуцлах',
      'noTransactions': 'Одоогоор гүйлгээ байхгүй байна',
      'financialAdvice': 'Санхүүгийн зөвлөгөө',
      'welcomeMessage': 'Сайн байна уу, {name}!',
      'monthlyFinance': '{month} сарын санхүүгийн бүртгэл',
      'addIncome': 'Орлого нэмэх',
      'addExpense': 'Зарлага нэмэх',
      'pleaseEnterDescription': 'Тайлбар оруулна уу',
      'pleaseEnterAmount': 'Дүн оруулна уу',
      'pleaseEnterValidAmount': 'Зөв дүн оруулна уу',
      'pleaseSelectCategory': 'Ангилал сонгоно уу',
      'totalIncome': 'Нийт орлого',
      'totalExpenses': 'Нийт зардал',
      'netIncome': 'Цэвэр орлого',
      'expenseAnalysis': 'Зардлын шинжилгээ',
      'recommendations': 'Зөвлөмжүүд',
      'savingsRate': 'Хадгаламжийн хувь',
      'yourCurrentSavingsRate': 'Таны одоогийн хадгаламжийн хувь:',
      'savingsRateGoal':
          'Санхүүгийн аюулгүй байдлыг бий болгохын тулд дор хаяж 20% зорилго тавь',
      'topExpenseCategory': 'Хамгийн их зардлын ангилал',
      'noExpensesRecorded': 'Одоогоор зардал бүртгэгдээгүй байна',
      'highestSpendingCategory': 'Таны хамгийн их зардал гаргасан ангилал:',
      'financialTip': 'Санхүүгийн зөвлөгөө',
      'financialTipDefault':
          '50/30/20 дүрмийг хэрэглэнэ үү: 50% хэрэгцээ, 30% хүсэл, 20% хадгаламж',
      'financialInsights': 'Санхүүгийн мэдээлэл',
    },
  };

  String translate(String key, {Map<String, String>? args}) {
    String translation = _localizedValues[locale.languageCode]?[key] ?? key;

    if (args != null) {
      args.forEach((argKey, argValue) {
        translation = translation.replaceAll('{$argKey}', argValue);
      });
    }

    return translation;
  }

  String formatCurrency(double amount) {
    final NumberFormat formatter = NumberFormat.currency(
      locale: locale.toString(),
      symbol: '₮',
      decimalDigits: 0,
    );
    return formatter.format(amount);
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat.yMd(locale.toString());
    return formatter.format(date);
  }

  String get monthlyReport =>
      _localizedValues[locale.languageCode]!['monthlyReport']!;
  String get totalIncome =>
      _localizedValues[locale.languageCode]!['totalIncome']!;
  String get totalExpenses =>
      _localizedValues[locale.languageCode]!['totalExpenses']!;
  String get netIncome => _localizedValues[locale.languageCode]!['netIncome']!;
  String get expenseAnalysis =>
      _localizedValues[locale.languageCode]!['expenseAnalysis']!;
  String get recommendations =>
      _localizedValues[locale.languageCode]!['recommendations']!;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'mn'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
