import 'package:flutter/material.dart';
import 'package:kpop_library/components/app_navigation_bar.dart';
import 'package:kpop_library/home.dart';
import 'package:kpop_library/editor.dart';
import 'package:kpop_library/view/artist.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kpop Library',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        splashColor: Colors.transparent,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: HomeScreen.routeName,
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        EditorScreen.routeName: (context) => const EditorScreen(),
        ArtistScreen.routeName: (context) => const ArtistScreen(),
        // DetailNewsScreen.routeName: (context) => DetailNewsScreen(
        //   args: ModalRoute.of(context)?.settings.arguments as List,
        // ),
      },
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) => AppContainer(child: child!),
            ),
          ],
        );
      },
    );
  }
}

class AppContainer extends StatefulWidget {
  final Widget child;

  const AppContainer({Key? key, required this.child}) : super(key: key);

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _selectedIndex = 0;

  void _changeActiveRoute() {
    switch (_selectedIndex) {
      case 0:
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (route) => false,
        );
        break;
      case 1:
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          EditorScreen.routeName,
          (route) => false,
        );
        break;
      case 2:
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          HomeScreen.routeName,
          (route) => false,
        );
        break;
      case 3:
        navigatorKey.currentState!.pushNamedAndRemoveUntil(
          EditorScreen.routeName,
          (route) => false,
        );
        break;
    }
  }

  void _changeSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
      _changeActiveRoute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: AppNavigationBar(
        callbackFunction: _changeSelectedIndex,
      ),
    );
  }
}
