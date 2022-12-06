import 'dart:async';
import 'package:flutter/widgets.dart';

class CurrentList extends InheritedWidget {
  final StreamController<String> _listController = StreamController<String>.broadcast();

  CurrentList({Key? key, required Widget child}) : super(key: key, child: child) {
    _listController.add("");
  }

  void setList(String newListId) {
    _listController.add(newListId);
  }
  Stream<String> get currentList => _listController.stream;

  @override
  bool updateShouldNotify(covariant CurrentList oldWidget) => true;

  static CurrentList of(BuildContext context) {
    final CurrentList? result = context.dependOnInheritedWidgetOfExactType<CurrentList>();
    assert(result != null, 'No CurrentList found in context');
    return result!;
  }
}
