import 'package:flutter/material.dart';

import '../../widgets/action_tiles.dart';
import '../../widgets/business_header.dart';
import '../../widgets/metric_cards.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        BusinessHeader('Tableau de bord Administratif', 'Contrôle global et supervision.'),
        MetricCards([
          MapEntry('Utilisateurs', '1240'),
          MapEntry('Annonces en attente', '31'),
          MapEntry('Fraudes signalées', '6'),
          MapEntry('Tickets support', '12'),
        ]),
      ],
    );
  }
}

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListView(
      children: [
        BusinessHeader('Gérer les utilisateurs', 'Activer ou désactiver les comptes.'),
        SwitchListTile(value: true, onChanged: null, title: Text('Locataire - Actif')),
        SwitchListTile(value: false, onChanged: null, title: Text('Propriétaire - Désactivé')),
      ],
    );
  }
}

class AdminAnnoncesPage extends StatelessWidget {
  const AdminAnnoncesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const BusinessHeader('Gérer les annonces', 'Valider ou refuser les annonces.'),
        actionTile('Annonce A-102', 'Studio centre', 'Valider', Icons.check_circle),
        actionTile('Annonce A-110', 'Loft premium', 'Refuser', Icons.cancel),
      ],
    );
  }
}

class ModerationPage extends StatelessWidget {
  const ModerationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const BusinessHeader('Modérations', 'Examiner et traiter les annonces signalées.'),
        actionTile('Fraude F-201', 'Annonce suspecte', 'Accepter', Icons.verified),
        actionTile('Fraude F-202', 'Photo non conforme', 'Refuser', Icons.block),
      ],
    );
  }
}

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListView(
      children: [
        BusinessHeader('Supports', 'Gestion des tickets de support.'),
        ListTile(
          leading: Icon(Icons.support_agent),
          title: Text('Ticket #S-9001'),
          subtitle: Text('Problème de connexion locataire'),
        ),
        ListTile(
          leading: Icon(Icons.support_agent),
          title: Text('Ticket #S-9002'),
          subtitle: Text('Annonce non validée'),
        ),
      ],
    );
  }
}

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListView(
      children: [
        BusinessHeader('Profil Administratif', 'Paramètres du compte administrateur.'),
        ListTile(title: Text('Nom'), subtitle: Text('Admin Binome')),
        ListTile(title: Text('Rôle'), subtitle: Text('Superviseur plateforme')),
      ],
    );
  }
}
