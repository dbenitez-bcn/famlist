import 'package:famlist/list.dart';
import 'package:famlist/presentation/pages/welcome_page.dart';
import 'package:famlist/presentation/state/list_state.dart';
import 'package:famlist/presentation/wigdet/custom_banner_ad.dart';
import 'package:famlist/presentation/wigdet/famlist_drawer.dart';
import 'package:famlist/presentation/wigdet/share_list_icon.dart';
import 'package:flutter/material.dart';

import '../wigdet/products_list_view.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SharedList?>(
      initialData: AppState.of(context).currentList,
      stream: AppState.of(context).currentListStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: [
              Expanded(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(snapshot.data!.title),
                    actions: const [
                      ShareListIcon(),
                    ],
                  ),
                  drawer: const FamlistDrawer(),
                  body: const ProductsListView(),
                  floatingActionButton: FloatingActionButton(
                    child: const Icon(Icons.add),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/newProduct'),
                  ),
                ),
              ),
              const CustomBannerAd(),
            ],
          );
        }
        return const WelcomePage();
      },
    );
  }
}
