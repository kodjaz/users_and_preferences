import 'package:weather_app_with_dart/database/database.dart';

Future<void> main() async {
  final db = AppDb();

  print('Deleting all users and preferences');

  await db.deleteAllUsersAndPreferences();

  print('Adding a new user and preferences');

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

  print('Closing the database connection');
  await db.close();
}
