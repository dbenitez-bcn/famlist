import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class NewListTile extends StatelessWidget {
  const NewListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.add_circle_outline,
        color: Colors.grey,
      ),
      title: Text("add_list".i18n()),
      onTap: () => Navigator.pushNamed(context, '/newList'),
    );
  }
}
