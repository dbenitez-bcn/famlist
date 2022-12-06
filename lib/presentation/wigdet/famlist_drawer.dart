import 'package:flutter/material.dart';

import '../../utils/literals.dart';

class FamlistDrawer extends StatelessWidget {
  const FamlistDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            child: const ListTile(
              leading: Icon(Icons.add_circle_outline),
              title: Text(addList),
            ),
            onTap: () => Navigator.pushNamed(context, '/newList'),
          ),
        ],
      ),
    );
  }
}