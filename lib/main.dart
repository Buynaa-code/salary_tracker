import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utils/app_theme.dart';
import 'utils/transaction_provider.dart';
import 'utils/app_localization.dart';
import 'screens/dashboard_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/add_transaction_screen.dart';
import 'models/transaction.dart';
import 'screens/report_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize shared preferences
  final prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('language_code');

  runApp(MyApp(
    initialLocale: languageCode != null ? Locale(languageCode) : null,
  ));
}

class MyApp extends StatefulWidget {
  final Locale? initialLocale;

  const MyApp({
    Key? key,
    this.initialLocale,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en', 'US');
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialLocale != null) {
      _locale = widget.initialLocale!;
    }
  }

  void _setLocale(Locale locale) async {
    setState(() {
      _locale = locale;
    });

    // Save the selected language code
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  void _setIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TransactionProvider(),
      child: MaterialApp(
        title: 'Salary Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: HomePage(
          selectedIndex: _selectedIndex,
          setIndex: _setIndex,
          setLocale: _setLocale,
        ),
        locale: _locale,
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('mn', 'MN'), // Mongolian
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final int selectedIndex;
  final Function(int) setIndex;
  final Function(Locale) setLocale;

  const HomePage({
    Key? key,
    required this.selectedIndex,
    required this.setIndex,
    required this.setLocale,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Initialize screens
    _screens = [
      const DashboardScreen(),
      const CalendarScreen(),
      const ReportScreen(),
      SettingsScreen(
        setLocale: widget.setLocale,
        notificationService: null,
      ),
    ];

    // Initialize and load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: appLocalizations.translate('dashboard'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: appLocalizations.translate('calendar'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.assessment),
            label: appLocalizations.translate('monthlyReport'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: appLocalizations.translate('settings'),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0 || _selectedIndex == 1
          ? FloatingActionButton(
              onPressed: () => _showTransactionDialog(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showTransactionDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.arrow_upward, color: Colors.green),
                title:
                    Text(AppLocalizations.of(context).translate('addIncome')),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionScreen(
                        type: TransactionType.income,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward, color: Colors.red),
                title:
                    Text(AppLocalizations.of(context).translate('addExpense')),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddTransactionScreen(
                        type: TransactionType.expense,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
