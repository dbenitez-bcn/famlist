import 'dart:async';
import 'package:flutter/widgets.dart';

class ListState extends InheritedWidget {
  final StreamController<String> _listController = StreamController<String>.broadcast();

  ListState({Key? key, required Widget child}) : super(key: key, child: child) {
    _listController.add("");
  }

  void setList(String newListId) {
    _listController.add(newListId);
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
