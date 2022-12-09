import 'package:flutter/material.dart';

import '../../utils/literals.dart';

class EmptyList extends StatelessWidget {
  const EmptyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            emptyListTitle,
            style: TextStyle(color: Colors.grey[700], fontSize: 32.0),
          ),
          Text(
            emptyListBody,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 24.0,
            ),
            textAlign: TextAlign.center,
          ),
          Icon(
            Icons.shopping_basket,
            color: Colors.grey[800],
            size: 150.0,
          )
        ],
      ),
    );
  }
}