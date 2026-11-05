// Whoever is logged in right now
class AppUser {
  const AppUser({
    required this.id,
    required this.username,
    required this.displayName,
  });

  final String id;
  final String username;
  final String displayName;

  AppUser copyWith({String? id, String? username, String? displayName}) {
    return AppUser(
      id: id ?? this.id,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppUser &&
        other.id == id &&
        other.username == username &&
        other.displayName == displayName;
  }

  @override
  int get hashCode => Object.hash(id, username, displayName);
}
