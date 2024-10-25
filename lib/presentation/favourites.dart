import 'package:flutter/material.dart';
import 'package:whisk_and_serve/core/widgets/base_scaffold.dart';

class Favourites extends StatelessWidget {
  const Favourites({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScaffold(
      child: Center(
        child: Text("favourites"),
      ),
    );
  }
}
