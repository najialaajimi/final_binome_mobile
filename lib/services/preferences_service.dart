import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_role.dart';

class PreferencesService {
  Future<bool> loadIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isDark') ?? false;
  }

  Future<UserRole> loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role') ?? UserRole.locataire.name;
    return UserRole.values.firstWhere(
      (r) => r.name == role,
      orElse: () => UserRole.locataire,
    );
  }

  Future<void> saveDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
  }

  Future<void> saveRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role.name);
  }
}
