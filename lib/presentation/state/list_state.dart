import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListState extends InheritedWidget {
  final StreamController<String> _listController = StreamController<String>.broadcast();
  late final SharedPreferences _sharedPreferences;

  ListState({Key? key, required Widget child, required SharedPreferences sharedPreferences}) : super(key: key, child: child) {
    _sharedPreferences = sharedPreferences;
  }

  void setList(String newListId) {
    _listController.add(newListId);
    _sharedPreferences.setString("last_list", newListId);
  }
  Stream<String> get currentList => _listController.stream;

  @override
  bool updateShouldNotify(covariant ListState oldWidget) => true;

  static ListState of(BuildContext context) {
    final ListState? result = context.dependOnInheritedWidgetOfExactType<ListState>();
    assert(result != null, 'No CurrentList found in context');
    return result!;
  }
}
