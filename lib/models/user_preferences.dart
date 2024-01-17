class UserPreferences {
  final int userId;
  final String city;
  final bool notificationsEnabled;

  UserPreferences(
      {required this.userId,
      required this.city,
      required this.notificationsEnabled});
}
