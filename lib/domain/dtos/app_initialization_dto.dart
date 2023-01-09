import 'package:famlist/list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInitializationDto {
  final SharedPreferences preferences;
  final SharedList? sharedList;

  AppInitializationDto(this.preferences, this.sharedList);
}