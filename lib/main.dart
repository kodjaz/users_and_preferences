import 'package:weather_app_with_dart/database/database.dart';

Future<void> main() async {
  final db = AppDb();

  // Колдонуучу кошуу
  final userId = await db.addUser('John Doe', 'johndoe@example.com');

  // Колдонуучунун тандоолорун кошуу
  await db.addUserPreference(userId, 'Bishkek', true);

  // Колдонуучуларды жана алардын тандоолорун алуу
  final usersWithPreferences = await db.getUsersWithPreferences();
  for (final userWithPref in usersWithPreferences) {
    var name = userWithPref.user.name;
    var city = userWithPref.preferences.city;
    print('User: $name, City: $city');
  }
}
