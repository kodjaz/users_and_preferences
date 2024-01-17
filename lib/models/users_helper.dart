import 'package:weather_app_with_dart/models/user.dart';
import 'package:weather_app_with_dart/models/user_preferences.dart';

class UserWithPreferences {
  final User user;
  final UserPreferences preferences;

  UserWithPreferences({required this.user, required this.preferences});
}
