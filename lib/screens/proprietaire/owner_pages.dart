import 'package:flutter/material.dart';

import '../../widgets/action_tiles.dart';
import '../../widgets/business_header.dart';
import '../../widgets/metric_cards.dart';

class OwnerDashboardPage extends StatelessWidget {
  const OwnerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        BusinessHeader('Tableau de bord Propriétaire', 'Pilotage de vos activités immobilières.'),
        MetricCards([
          MapEntry('Annonces actives', '14'),
          MapEntry('Demandes visites', '8'),
          MapEntry('Demandes réservation', '5'),
        ]),
      ],
    );
  }
}

class OwnerAnnonceManagementPage extends StatelessWidget {
  const OwnerAnnonceManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        BusinessHeader('Gérer les annonces', 'Liste, ajout, modification, activation.'),
        SwitchListTile(value: true, onChanged: null, title: Text('Studio centre - Actif')),
        SwitchListTile(value: false, onChanged: null, title: Text('Loft jardin - Désactivé')),
      ],
    );
  }
}

class PublishAnnoncePage extends StatelessWidget {
  const PublishAnnoncePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        BusinessHeader('Publier annonce', 'Créer une nouvelle annonce premium.'),
        TextField(decoration: InputDecoration(labelText: 'Titre')),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(labelText: 'Prix')),
        SizedBox(height: 12),
        TextField(decoration: InputDecoration(labelText: 'Localisation')),
        SizedBox(height: 12),
        TextField(maxLines: 3, decoration: InputDecoration(labelText: 'Description')),
      ],
    );
  }
}

class VisitRequestsPage extends StatelessWidget {
  const VisitRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const BusinessHeader('Demandes de visites', 'Confirmer les demandes reçues.'),
        confirmableTile('Amine - Studio centre', '12/06/2026 17:30'),
        confirmableTile('Nour - Appartement lac', '13/06/2026 11:00'),
      ],
    );
  }
}

class ReservationRequestsPage extends StatelessWidget {
  const ReservationRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const BusinessHeader('Demandes de réservation', 'Confirmer les demandes de réservation.'),
        confirmableTile('Moez - Loft moderne', 'Demande #R-1021'),
        confirmableTile('Sana - Studio premium', 'Demande #R-1044'),
      ],
    );
  }
}

class OwnerProfilePage extends StatelessWidget {
  const OwnerProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListView(
      children: [
        BusinessHeader('Profil Propriétaire', 'Informations de compte et contact.'),
        ListTile(title: Text('Nom'), subtitle: Text('Propriétaire Premium')),
        ListTile(title: Text('Email'), subtitle: Text('owner@binome.tn')),
      ],
    );
  }
}
