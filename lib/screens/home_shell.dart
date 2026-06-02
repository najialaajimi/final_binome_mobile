import 'package:flutter/material.dart';

import '../models/user_role.dart';
import '../utils/role_config.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({
    required this.role,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onRoleChanged,
    super.key,
  });

  final UserRole role;
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<UserRole> onRoleChanged;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _selectedIndex = 0;

  @override
  void didUpdateWidget(covariant HomeShell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.role != widget.role) {
      setState(() => _selectedIndex = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = pagesByRole(widget.role);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Binome'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<UserRole>(
              value: widget.role,
              onChanged: (v) {
                if (v != null) widget.onRoleChanged(v);
              },
              items: UserRole.values
                  .map(
                    (r) => DropdownMenuItem(
                      value: r,
                      child: Text(roleLabel(r)),
                    ),
                  )
                  .toList(),
            ),
          ),
          Row(
            children: [
              const Icon(Icons.dark_mode),
              Switch(
                value: widget.isDarkMode,
                onChanged: widget.onThemeChanged,
              ),
            ],
          ),
        ],
      ),
      body: pages[_selectedIndex].widget,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (value) {
          setState(() => _selectedIndex = value);
        },
        destinations: pages
            .map(
              (entry) => NavigationDestination(
                icon: const Icon(Icons.circle_outlined),
                selectedIcon: const Icon(Icons.circle),
                label: entry.label,
              ),
            )
            .toList(),
      ),
    );
  }
}
