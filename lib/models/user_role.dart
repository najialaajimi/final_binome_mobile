enum UserRole { locataire, proprietaire, administratif }

String roleLabel(UserRole role) {
  switch (role) {
    case UserRole.locataire:
      return 'Locataire';
    case UserRole.proprietaire:
      return 'Propriétaire';
    case UserRole.administratif:
      return 'Administratif';
  }
}
