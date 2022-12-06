import 'package:famlist/presentation/wigdet/famlist_drawer.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tu lista de la compra"),
        ),
        drawer: const FamlistDrawer(),
        body: const Text("Hello hello")
    );
  }
}
