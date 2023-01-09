import 'dart:async';

import 'package:famlist/list.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:famlist/utils/constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends InheritedWidget {
  final StreamController<SharedList> _listController =
      StreamController<SharedList>.broadcast();
  final SharedPreferences _sharedPreferences;
  SharedList? _currentList;
  int _productsAdded = 0;

  AppState(
    this._sharedPreferences,
    this._currentList, {
    Key? key,
    required Widget child,
  }) : super(key: key, child: child) {
    FirebaseDynamicLinks.instance.onLink.listen((linkData) {
      var pathArray = linkData.link.pathSegments;
      if (pathArray.isNotEmpty) {
        String listId = linkData.link.pathSegments[0];
        ListsService.addSharedList(listId).then((value) => setList(value));
      }
    });
  }

  void setList(SharedList newList) {
    _currentList = newList;
    _listController.sink.add(newList);
    _sharedPreferences.setString(LAST_LIST_ID_KEY, newList.id);
  }

  Future<void> updateListTitle(String newTitle) async {
    SharedList newList = SharedList(_currentList!.id, newTitle);
    setList(newList);
    await ListsService.updateList(_currentList!);
  }

  Stream<SharedList> get currentListStream => _listController.stream;

  SharedList? get currentList => _currentList;

  void increaseProductAdded() async {
    _productsAdded++;
    if (_productsAdded == 3) {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }
  }

  Future<void> removeCurrentList() async {
    await ListsService.removeSharedList(_currentList!.id);
    // _
  }

  Stream<List<SharedList>> get userLists => ListsService.getSharedLists();

  @override
  bool updateShouldNotify(covariant AppState oldWidget) => true;

  static AppState of(BuildContext context) {
    final AppState? result =
        context.dependOnInheritedWidgetOfExactType<AppState>();
    assert(result != null, 'No CurrentList found in context');
    return result!;
  }
}
