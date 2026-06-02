import 'package:flutter/material.dart';

import 'models/user_role.dart';
import 'screens/home_shell.dart';
import 'services/preferences_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BinomeApp());
}

class BinomeApp extends StatefulWidget {
  const BinomeApp({super.key});

  @override
  State<BinomeApp> createState() => _BinomeAppState();
}

class _BinomeAppState extends State<BinomeApp> {
  final PreferencesService _preferencesService = PreferencesService();
  ThemeMode _themeMode = ThemeMode.light;
  UserRole _role = UserRole.locataire;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final isDark = await _preferencesService.loadIsDarkMode();
    final role = await _preferencesService.loadRole();
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      _role = role;
    });
  }

  Future<void> _toggleTheme(bool isDark) async {
    await _preferencesService.saveDarkMode(isDark);
    setState(() => _themeMode = isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _changeRole(UserRole role) async {
    await _preferencesService.saveRole(role);
    setState(() => _role = role);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Binome',
      themeMode: _themeMode,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A4A8D)),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A4A8D),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: HomeShell(
        role: _role,
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
        onRoleChanged: _changeRole,
      ),
    );
  }
}
