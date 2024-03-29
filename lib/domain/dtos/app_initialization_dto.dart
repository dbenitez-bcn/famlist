import 'package:famlist/list.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInitializationDto {
  final SharedPreferences preferences;
  final ListsService listsService;
  final SharedList? sharedList;
  final List<SharedList> userLists;

  AppInitializationDto(
      this.preferences, this.listsService, this.sharedList, this.userLists);
}
