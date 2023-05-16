import 'package:flutter/material.dart';

class AppNavigationBar extends StatefulWidget {
  final Function callbackFunction;

  const AppNavigationBar({
    Key? key,
    required this.callbackFunction,
  }) : super(key: key);

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int _itemSelectedIndex = 0;

  final List<Icon> selectedIcons = [
    const Icon(Icons.home),
    const Icon(Icons.search),
    const Icon(Icons.library_music),
    const Icon(Icons.manage_accounts),
  ];
  final List<Icon> outlinedIcons = [
    const Icon(Icons.home_outlined),
    const Icon(Icons.search_outlined),
    const Icon(Icons.library_music_outlined),
    const Icon(Icons.manage_accounts_outlined),
  ];
  final List<String> itemLabels = [
    "Home",
    "Search",
    "Library",
    "Account",
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: List.generate(outlinedIcons.length, (index) {
        return BottomNavigationBarItem(
          icon: _itemSelectedIndex == index
              ? selectedIcons[index]
              : outlinedIcons[index],
          label: itemLabels[index],
        );
      }),
      currentIndex: _itemSelectedIndex,
      onTap: (int index) {
        setState(() {
          _itemSelectedIndex = index;
          widget.callbackFunction(_itemSelectedIndex);
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 12.0,
      unselectedFontSize: 12.0,
    );
  }
}
