import 'package:era_uma_editor/presentation/pages/main/about_page.dart';
import 'package:era_uma_editor/presentation/pages/main/global_page.dart';
import 'package:era_uma_editor/presentation/pages/main/item_page.dart';
import 'package:era_uma_editor/presentation/pages/main/overview_page.dart';
import 'package:era_uma_editor/presentation/widgets/character_list_view.dart';
import 'package:flutter/material.dart';

class MainScreenWindows extends StatefulWidget {
  const MainScreenWindows({super.key});

  @override
  State<MainScreenWindows> createState() => _MainScreenWindowsState();
}

class _MainScreenWindowsState extends State<MainScreenWindows> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    OverviewPage(),
    CharacterListView(),
    ItemPage(),
    GlobalPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: Text('概览'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: Text('角色'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('物品'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.public_outlined),
                selectedIcon: Icon(Icons.public),
                label: Text('全局'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.info_outline),
                selectedIcon: Icon(Icons.info),
                label: Text('关于'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_selectedIndex),
                child: _pages[_selectedIndex],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
