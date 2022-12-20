import 'dart:async';
import 'package:famlist/utils/constants.dart';
import 'package:famlist/utils/literals.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends InheritedWidget {
  final StreamController<String> _listController = StreamController<String>.broadcast();
  late final SharedPreferences _sharedPreferences;
  String _currentList = ""; // TODO: Change it to a shared_list type (ideal for list editing name)

  AppState({Key? key, required Widget child, required SharedPreferences sharedPreferences}) : super(key: key, child: child) {
    _sharedPreferences = sharedPreferences;
    setList(_sharedPreferences.getString(LAST_LIST_ID_KEY) ?? appName);
  }

  void setList(String newListId) {
    _currentList = newListId;
    _listController.sink.add(newListId);
    _sharedPreferences.setString(LAST_LIST_ID_KEY, newListId);
  }
  Stream<String> get currentListStream => _listController.stream;
  String get currentListId => _currentList;

  @override
  bool updateShouldNotify(covariant AppState oldWidget) => true;

  static AppState of(BuildContext context) {
    final AppState? result = context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'No CurrentList found in context');
    return result!;
  }
}
