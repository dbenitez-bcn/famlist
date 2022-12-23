import 'dart:async';

import 'package:famlist/utils/constants.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends InheritedWidget {
  final StreamController<String> _listController =
      StreamController<String>.broadcast();
  late final SharedPreferences _sharedPreferences;
  String? _currentList; // TODO: Change it to a shared_list type (ideal for list editing name)
  int _productsAdded = 0;

  AppState({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  void setList(String newListId) {
    _currentList = newListId;
    _listController.sink.add(newListId);
    _sharedPreferences.setString(LAST_LIST_ID_KEY, newListId);
  }

  Stream<String> get currentListStream => _listController.stream;

  String? get currentListId => _currentList;

  void increaseProductAdded() async {
    _productsAdded++;
    if (_productsAdded == 3) {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }
  }
  void setSharedPreferences(SharedPreferences preferences) {
    _sharedPreferences = preferences;
    String? listId = _sharedPreferences.getString(LAST_LIST_ID_KEY);
    if (listId != null) {
      _currentList = listId;
      _listController.sink.add(listId);
    }
  }

  @override
  bool updateShouldNotify(covariant AppState oldWidget) => true;

  static AppState of(BuildContext context) {
    final AppState? result =
        context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'No CurrentList found in context');
    return result!;
  }
}
