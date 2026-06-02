import 'package:flutter/widgets.dart';

import '../models/user_role.dart';
import '../screens/administratif/admin_pages.dart';
import '../screens/locataire/tenant_pages.dart';
import '../screens/proprietaire/owner_pages.dart';

class PageEntry {
  const PageEntry(this.label, this.widget);

  final String label;
  final Widget widget;
}

List<PageEntry> pagesByRole(UserRole role) {
  switch (role) {
    case UserRole.locataire:
      return const [
        PageEntry('Dashboard', TenantDashboardPage()),
        PageEntry('Annonces', TenantAnnoncesPage()),
        PageEntry('Favoris', FavoritesPage()),
        PageEntry('Recherche', CompatibilitySearchPage()),
        PageEntry('Chats', ChatPage()),
        PageEntry('Réservation', ReservationPage()),
        PageEntry('Visite', VisitPage()),
        PageEntry('Profil', TenantProfilePage()),
        PageEntry('Map', OpenStreetMapPage()),
      ];
    case UserRole.proprietaire:
      return const [
        PageEntry('Dashboard', OwnerDashboardPage()),
        PageEntry('Annonces', OwnerAnnonceManagementPage()),
        PageEntry('Publier', PublishAnnoncePage()),
        PageEntry('Visites', VisitRequestsPage()),
        PageEntry('Réservations', ReservationRequestsPage()),
        PageEntry('Profil', OwnerProfilePage()),
      ];
    case UserRole.administratif:
      return const [
        PageEntry('Dashboard', AdminDashboardPage()),
        PageEntry('Utilisateurs', UserManagementPage()),
        PageEntry('Annonces', AdminAnnoncesPage()),
        PageEntry('Modération', ModerationPage()),
        PageEntry('Support', SupportPage()),
        PageEntry('Profil', AdminProfilePage()),
      ];
  }
}
