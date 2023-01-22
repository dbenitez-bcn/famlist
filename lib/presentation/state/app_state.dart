import 'dart:async';

import 'package:famlist/domain/product.dart';
import 'package:famlist/list.dart';
import 'package:famlist/services/lists_service.dart';
import 'package:famlist/utils/constants.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/widgets.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends InheritedWidget {
  final StreamController<SharedList?> _listController =
      StreamController<SharedList?>.broadcast();
  final SharedPreferences _sharedPreferences;
  final ListsService _listsService;
  SharedList? _currentList;
  int _productsAdded = 0;
  final List<SharedList> initialUserLists;

  AppState(
    this._sharedPreferences,
    this._listsService,
    this._currentList,
    this.initialUserLists, {
    Key? key,
    required Widget child,
  }) : super(key: key, child: child) {
    FirebaseDynamicLinks.instance.onLink.listen((linkData) {
      var pathArray = linkData.link.pathSegments;
      if (pathArray.isNotEmpty) {
        String listId = linkData.link.pathSegments[0];
        _listsService.addSharedList(listId).then((value) => setList(value));
      }
    });
  }

  Stream<SharedList?> get currentListStream => _listController.stream;

  SharedList? get currentList => _currentList;

  Stream<List<SharedList>> get userLists => _listsService.getSharedLists();

  void setList(SharedList? newList) {
    _currentList = newList;
    _listController.sink.add(newList);
    if (newList == null) {
      _sharedPreferences.remove(LAST_LIST_ID_KEY);
    } else {
      _sharedPreferences.setString(LAST_LIST_ID_KEY, newList.id);
    }
  }

  Future<void> addList(String title) async {
    setList(await _listsService.addList(title));
  }

  Future<void> updateListTitle(String newTitle) async {
    SharedList newList = SharedList(_currentList!.id, newTitle);
    setList(newList);
    await _listsService.updateList(_currentList!);
  }

  Future<void> removeCurrentList() async {
    await _listsService.removeSharedList(_currentList!.id);
    setList(await _listsService.getFirstSharedList());
  }

  void increaseProductAdded() async {
    _productsAdded++;
    if (_productsAdded == 3) {
      final InAppReview inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
      }
    }
  }

  void increaseQuantity(Product product) async {
    _listsService.increaseQuantity(currentList!.id, product);
  }

  Stream<List<Product>> getProducts(String listId) {
    return _listsService.getProducts(listId);
  }

  void addProduct(String title, String description) {
    _listsService.addProduct(currentList!.id, title, description);
  }

  void removeProduct(String productId) {
    _listsService.removeProduct(currentList!.id, productId);
  }

  void updateProduct(Product product) {
    _listsService.updateProduct(currentList!.id, product);
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
