import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:weather_app_with_dart/models/user.dart';
import 'package:weather_app_with_dart/models/user_preferences.dart';
import 'package:weather_app_with_dart/models/user_table.dart';
import 'package:weather_app_with_dart/models/user_preferences_table.dart';
import 'package:weather_app_with_dart/models/users_helper.dart';

part 'database.g.dart';

@DriftDatabase(tables: [UserTable, UserPreferencesTable])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> addUser(String name, String email) {
    return into(userTable).insert(UserTableCompanion(
      name: Value(name),
      email: Value(email),
    ));
  }

  Future<void> deleteAllUsersAndPreferences() async {
    // Биринчи кезекте UserPreferencesTable таблицасындагы бардык маалыматтарды өчүрүү
    await (delete(userPreferencesTable)).go();

    // Эми userTable таблицасындагы бардык маалыматтарды өчүрүү
    await (delete(userTable)).go();
  }

  Future<int> addUserPreference(
      int userId, String city, bool notificationsEnabled) {
    return into(userPreferencesTable).insert(UserPreferencesTableCompanion(
      userId: Value(userId),
      city: Value(city),
      notificationsEnabled: Value(notificationsEnabled),
    ));
  }

  Future<List<UserWithPreferences>> getUsersWithPreferences() async {
    final query = select(userTable).join(
      [
        leftOuterJoin(
          userPreferencesTable,
          userPreferencesTable.userId.equalsExp(userTable.id),
        ),
      ],
    );
    final rows = await query.get();
    return rows.map((row) {
      final userRow = row.readTable(userTable);
      final userPreferencesRow = row.readTable(userPreferencesTable);

      // Create User and UserPreferences instances
      final userInstance = User(
        id: userRow.id,
        name: userRow.name,
        email: userRow.email,
      );
      final userPreferencesInstance = UserPreferences(
        userId: userPreferencesRow.userId,
        city: userPreferencesRow.city,
        notificationsEnabled: userPreferencesRow.notificationsEnabled,
      );

      return UserWithPreferences(
        user: userInstance,
        preferences: userPreferencesInstance,
      );
    }).toList();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // Use the current directory as the database folder
    final dbFolder = Directory.current;
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
