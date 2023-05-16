import 'package:flutter/material.dart';
import 'package:kpop_library/view/artist.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          ElevatedButton(
            style: ButtonStyle(
                // backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                ),
            onPressed: () {
              Navigator.pushNamed(context, ArtistScreen.routeName);
            },
            child: const Text("Artist"),
          )
        ],
      ),
    );
  }
}
