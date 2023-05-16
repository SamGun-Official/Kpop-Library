import 'package:flutter/material.dart';
// import 'package:kpop_library/editor.dart';
// import 'package:kpop_library/components/app_navigation_bar.dart';

class ArtistScreen extends StatelessWidget {
  static const routeName = '/artist';

  const ArtistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Artist"),
      ),
      body: Column(
        children: [
        ],
      ),
      // bottomNavigationBar: const AppNavigationBar(),
    );
  }
}
