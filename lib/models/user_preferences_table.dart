import 'package:drift/drift.dart';

class UserPreferencesTable extends Table {
  IntColumn get userId => integer().customConstraint('REFERENCES user(id)')();
  TextColumn get city => text()();
  BoolColumn get notificationsEnabled => boolean()();
}
