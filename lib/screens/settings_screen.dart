import 'package:flutter/material.dart';
import '../utils/app_localization.dart';

class SettingsScreen extends StatefulWidget {
  final dynamic notificationService;
  final Function(Locale) setLocale;

  const SettingsScreen({
    Key? key,
    this.notificationService,
    required this.setLocale,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = false;
  ThemeMode _themeMode = ThemeMode.system;
  String _selectedLanguage = 'en';

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.translate('settings')),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(appLocalizations.translate('language')),
            trailing: DropdownButton<String>(
              value: _selectedLanguage,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _selectedLanguage = value;
                });
                // Update app locale
                widget.setLocale(Locale(value));
              },
              items: [
                DropdownMenuItem(
                  value: 'en',
                  child: Text(appLocalizations.translate('english')),
                ),
                DropdownMenuItem(
                  value: 'mn',
                  child: Text(appLocalizations.translate('mongolian')),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: Text(appLocalizations.translate('theme')),
            trailing: DropdownButton<ThemeMode>(
              value: _themeMode,
              onChanged: (ThemeMode? value) {
                if (value == null) return;
                setState(() {
                  _themeMode = value;
                });
                // Theme would be changed at app level
                // This is a placeholder for now
              },
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(appLocalizations.translate('systemDefault')),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(appLocalizations.translate('lightMode')),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(appLocalizations.translate('darkMode')),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(appLocalizations.translate('taxInfo')),
            subtitle: Text(appLocalizations.translate('taxRate')),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Show tax info dialog
              _showTaxInfoDialog(context);
            },
          ),
          const Divider(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Salary Tracker v1.0.0',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  void _showTaxInfoDialog(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(appLocalizations.translate('taxInfo')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('• ${appLocalizations.translate('income')} > 50,000: 10%'),
              const SizedBox(height: 8),
              Text('• ${appLocalizations.translate('income')} > 30,000: 5%'),
              const SizedBox(height: 8),
              Text('• ${appLocalizations.translate('income')} <= 30,000: 0%'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(appLocalizations.translate('close')),
            ),
          ],
        );
      },
    );
  }
}
