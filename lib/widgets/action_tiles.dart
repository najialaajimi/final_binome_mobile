import 'package:flutter/material.dart';

Widget confirmableTile(String title, String subtitle) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: FilledButton(onPressed: () {}, child: const Text('Confirmer')),
    ),
  );
}

Widget actionTile(String code, String subtitle, String action, IconData icon) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      title: Text(code),
      subtitle: Text(subtitle),
      trailing: FilledButton.icon(onPressed: () {}, icon: Icon(icon), label: Text(action)),
    ),
  );
}
