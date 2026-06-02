import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BinomeApp());
}

enum UserRole { locataire, proprietaire, administratif }

class BinomeApp extends StatefulWidget {
  const BinomeApp({super.key});

  @override
  State<BinomeApp> createState() => _BinomeAppState();
}

class _BinomeAppState extends State<BinomeApp> {
  ThemeMode _themeMode = ThemeMode.light;
  UserRole _role = UserRole.locataire;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    final role = prefs.getString('role') ?? UserRole.locataire.name;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      _role = UserRole.values.firstWhere(
        (r) => r.name == role,
        orElse: () => UserRole.locataire,
      );
    });
  }

  Future<void> _toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
    setState(() => _themeMode = isDark ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> _changeRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role.name);
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
    final pages = _pagesByRole(widget.role);
    final labels = pages.map((e) => e.label).toList();

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
                      child: Text(_roleLabel(r)),
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
        destinations: labels
            .map(
              (label) => NavigationDestination(
                icon: const Icon(Icons.circle_outlined),
                selectedIcon: const Icon(Icons.circle),
                label: label,
              ),
            )
            .toList(),
      ),
    );
  }
}

String _roleLabel(UserRole role) {
  switch (role) {
    case UserRole.locataire:
      return 'Locataire';
    case UserRole.proprietaire:
      return 'Propriétaire';
    case UserRole.administratif:
      return 'Administratif';
  }
}

class _PageEntry {
  const _PageEntry(this.label, this.widget);
  final String label;
  final Widget widget;
}

List<_PageEntry> _pagesByRole(UserRole role) {
  switch (role) {
    case UserRole.locataire:
      return const [
        _PageEntry('Dashboard', TenantDashboardPage()),
        _PageEntry('Annonces', TenantAnnoncesPage()),
        _PageEntry('Favoris', FavoritesPage()),
        _PageEntry('Recherche', CompatibilitySearchPage()),
        _PageEntry('Chats', ChatPage()),
        _PageEntry('Réservation', ReservationPage()),
        _PageEntry('Visite', VisitPage()),
        _PageEntry('Profil', TenantProfilePage()),
        _PageEntry('Map', OpenStreetMapPage()),
      ];
    case UserRole.proprietaire:
      return const [
        _PageEntry('Dashboard', OwnerDashboardPage()),
        _PageEntry('Annonces', OwnerAnnonceManagementPage()),
        _PageEntry('Publier', PublishAnnoncePage()),
        _PageEntry('Visites', VisitRequestsPage()),
        _PageEntry('Réservations', ReservationRequestsPage()),
        _PageEntry('Profil', OwnerProfilePage()),
      ];
    case UserRole.administratif:
      return const [
        _PageEntry('Dashboard', AdminDashboardPage()),
        _PageEntry('Utilisateurs', UserManagementPage()),
        _PageEntry('Annonces', AdminAnnoncesPage()),
        _PageEntry('Modération', ModerationPage()),
        _PageEntry('Support', SupportPage()),
        _PageEntry('Profil', AdminProfilePage()),
      ];
  }
}

class BusinessHeader extends StatelessWidget {
  const BusinessHeader(this.title, this.subtitle, {super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A4A8D), Color(0xFF0B8DD0)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class MetricCards extends StatelessWidget {
  const MetricCards(this.metrics, {super.key});

  final List<MapEntry<String, String>> metrics;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: metrics
            .map(
              (m) => SizedBox(
                width: 160,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.key, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          m.value,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

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
        _confirmableTile('Amine - Studio centre', '12/06/2026 17:30'),
        _confirmableTile('Nour - Appartement lac', '13/06/2026 11:00'),
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
        _confirmableTile('Moez - Loft moderne', 'Demande #R-1021'),
        _confirmableTile('Sana - Studio premium', 'Demande #R-1044'),
      ],
    );
  }
}

Widget _confirmableTile(String title, String subtitle) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: FilledButton(onPressed: () {}, child: const Text('Confirmer')),
    ),
  );
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
        _actionTile('Annonce A-102', 'Studio centre', 'Valider', Icons.check_circle),
        _actionTile('Annonce A-110', 'Loft premium', 'Refuser', Icons.cancel),
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
        const BusinessHeader('Modérations', 'Accepter ou refuser les annonces frauduleuses.'),
        _actionTile('Fraude F-201', 'Annonce suspecte', 'Accepter', Icons.verified),
        _actionTile('Fraude F-202', 'Photo non conforme', 'Refuser', Icons.block),
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

Widget _actionTile(String code, String subtitle, String action, IconData icon) {
  return Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: ListTile(
      title: Text(code),
      subtitle: Text(subtitle),
      trailing: FilledButton.icon(onPressed: () {}, icon: Icon(icon), label: Text(action)),
    ),
  );
}
