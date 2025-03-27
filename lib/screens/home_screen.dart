import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import '../utils/transaction_provider.dart';
import '../utils/app_localization.dart';
import 'dashboard_screen.dart';
import 'calendar_screen.dart';
import 'reports_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final NotificationService notificationService;
  final Function(Locale) setLocale;

  const HomeScreen({
    Key? key,
    required this.notificationService,
    required this.setLocale,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize and load data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionProvider>(context, listen: false).loadData();
    });

    // Setup daily reminder notification
    _setupDailyReminder();

    // Initialize screens
    _screens = [
      const DashboardScreen(),
      const CalendarScreen(),
      const ReportsScreen(),
      SettingsScreen(
        notificationService: widget.notificationService,
        setLocale: widget.setLocale,
      ),
    ];
  }

  Future<void> _setupDailyReminder() async {
    await widget.notificationService.scheduleDailyNotification(
      title: 'Salary Tracker',
      body: 'Don\'t forget to log your transactions today!',
      hour: 20,
      minute: 0,
    );
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
            icon: const Icon(Icons.home),
            label: appLocalizations.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: appLocalizations.translate('calendar'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: appLocalizations.translate('reports'),
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
                  // Navigation to add income screen
                  // We'll implement this in the next steps
                },
              ),
              ListTile(
                leading: const Icon(Icons.arrow_downward, color: Colors.red),
                title:
                    Text(AppLocalizations.of(context).translate('addExpense')),
                onTap: () {
                  Navigator.pop(context);
                  // Navigation to add expense screen
                  // We'll implement this in the next steps
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
