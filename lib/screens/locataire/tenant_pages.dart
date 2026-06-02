import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../widgets/business_header.dart';
import '../../widgets/metric_cards.dart';

class TenantDashboardPage extends StatelessWidget {
  const TenantDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        BusinessHeader('Tableau de bord Locataire', 'Vue globale, premium et claire.'),
        MetricCards([
          MapEntry('Annonces actives', '28'),
          MapEntry('Matchs binôme', '9'),
          MapEntry('Réservations', '4'),
          MapEntry('Visites', '3'),
        ]),
      ],
    );
  }
}

class TenantAnnoncesPage extends StatelessWidget {
  const TenantAnnoncesPage({super.key});

  static const _annonces = [
    {
      'title': 'Studio premium - Centre Ville',
      'image': 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=900',
      'city': 'Tunis',
      'price': '1200 DT/mois',
    },
    {
      'title': 'Appartement business - Lac',
      'image': 'https://images.unsplash.com/photo-1460317442991-0ec209397118?w=900',
      'city': 'Lac 2',
      'price': '1800 DT/mois',
    },
    {
      'title': 'Loft moderne - Sousse',
      'image': 'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=900',
      'city': 'Sousse',
      'price': '1400 DT/mois',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _annonces.length,
      itemBuilder: (context, index) {
        final annonce = _annonces[index];
        return Card(
          margin: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  annonce['image']!,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 170,
                    child: Center(child: Icon(Icons.image_not_supported)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      annonce['title']!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text('${annonce['city']} • ${annonce['price']}'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.favorite_border),
                          label: const Text('Favoris'),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.event_available),
                          label: const Text('Réserver'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListView(
      children: [
        BusinessHeader('Favoris d\'annonces', 'Vos biens sauvegardés.'),
        ListTile(
          leading: Icon(Icons.favorite, color: Colors.red),
          title: Text('Appartement vue mer'),
          subtitle: Text('Nabeul • 1600 DT/mois'),
        ),
        ListTile(
          leading: Icon(Icons.favorite, color: Colors.red),
          title: Text('Studio Smart Living'),
          subtitle: Text('Ariana • 1100 DT/mois'),
        ),
      ],
    );
  }
}

class CompatibilitySearchPage extends StatelessWidget {
  const CompatibilitySearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        BusinessHeader('Recherche Binôme', 'Compatibilité basée sur lifestyle.'),
        Card(
          child: ListTile(
            title: Text('Yassine B.'),
            subtitle: Text('Compatibilité: 91% • Non-fumeur • Sportif'),
            trailing: Icon(Icons.handshake),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Meriem K.'),
            subtitle: Text('Compatibilité: 85% • Calme • Télétravail'),
            trailing: Icon(Icons.handshake),
          ),
        ),
      ],
    );
  }
}

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        BusinessHeader('Discussion Chat', 'Locataire ↔ Locataire / Locataire ↔ Propriétaire.'),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text('Ali - Propriétaire'),
          subtitle: Text('Visite confirmée demain à 18h.'),
          trailing: Icon(Icons.chat),
        ),
        ListTile(
          leading: CircleAvatar(child: Icon(Icons.person_2)),
          title: Text('Sarra - Binôme potentiel'),
          subtitle: Text('Je suis intéressée par ce quartier.'),
          trailing: Icon(Icons.chat_bubble_outline),
        ),
      ],
    );
  }
}

class ReservationPage extends StatefulWidget {
  const ReservationPage({super.key});

  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  final List<String> _reservations = ['Studio premium - 12/06/2026'];

  Future<void> _addReservation() async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter réservation'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Annonce + Date'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _reservations.add(controller.text.trim()));
              }
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const BusinessHeader('Réservation', 'Liste et ajout de réservations.'),
          ..._reservations.map((r) => ListTile(title: Text(r), trailing: const Icon(Icons.bookmark))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addReservation,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }
}

class VisitPage extends StatefulWidget {
  const VisitPage({super.key});

  @override
  State<VisitPage> createState() => _VisitPageState();
}

class _VisitPageState extends State<VisitPage> {
  final List<String> _visits = ['Appartement business - 15/06/2026'];

  Future<void> _addVisit() async {
    final controller = TextEditingController();
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter visite'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Annonce + Date'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() => _visits.add(controller.text.trim()));
              }
              Navigator.pop(context);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const BusinessHeader('Visite annonce', 'Liste et ajout de demandes de visite.'),
          ..._visits.map((v) => ListTile(title: Text(v), trailing: const Icon(Icons.home_work_outlined))),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addVisit,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
      ),
    );
  }
}

class TenantProfilePage extends StatelessWidget {
  const TenantProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        BusinessHeader('Profil Locataire', 'Lifestyle et préférences de colocation.'),
        ListTile(title: Text('Lifestyle'), subtitle: Text('Calme, sport, non-fumeur, couche-tôt')),
        ListTile(title: Text('Budget'), subtitle: Text('1200 - 1600 DT')),
      ],
    );
  }
}

class OpenStreetMapPage extends StatelessWidget {
  const OpenStreetMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(initialCenter: LatLng(36.8065, 10.1815), initialZoom: 12),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.binome.final_binome_mobile',
        ),
        const MarkerLayer(
          markers: [
            Marker(
              point: LatLng(36.8065, 10.1815),
              width: 80,
              height: 80,
              child: Icon(Icons.location_pin, size: 40, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
