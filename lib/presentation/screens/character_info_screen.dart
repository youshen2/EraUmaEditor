import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:era_uma_editor/presentation/pages/character_info/ability_page.dart';
import 'package:era_uma_editor/presentation/pages/character_info/attr_page.dart';
import 'package:era_uma_editor/presentation/pages/character_info/callname_page.dart';
import 'package:era_uma_editor/presentation/pages/character_info/exp_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

class CharacterInfoScreen extends ConsumerStatefulWidget {
  final int characterId;

  const CharacterInfoScreen({super.key, required this.characterId});

  @override
  ConsumerState<CharacterInfoScreen> createState() =>
      _CharacterInfoScreenState();
}

class _CharacterInfoScreenState extends ConsumerState<CharacterInfoScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;
  late final List<NavigationDestination> _destinations;
  late final List<NavigationRailDestination> _railDestinations;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      AttrPage(characterId: widget.characterId),
      CallnamePage(characterId: widget.characterId),
      AbilityPage(characterId: widget.characterId),
      ExpPage(characterId: widget.characterId),
    ];

    const pageConfigs = [
      {'label': '属性', 'icon': Icons.tune_outlined, 'selectedIcon': Icons.tune},
      {
        'label': '称呼',
        'icon': Icons.tag_faces_outlined,
        'selectedIcon': Icons.tag_faces
      },
      {
        'label': '能力',
        'icon': Icons.shield_outlined,
        'selectedIcon': Icons.shield
      },
      {
        'label': '经验',
        'icon': Icons.emoji_events_outlined,
        'selectedIcon': Icons.emoji_events
      },
    ];

    _destinations = pageConfigs
        .map((p) => NavigationDestination(
              icon: Icon(p['icon'] as IconData),
              selectedIcon: Icon(p['selectedIcon'] as IconData),
              label: p['label'] as String,
            ))
        .toList();

    _railDestinations = pageConfigs
        .map((p) => NavigationRailDestination(
              icon: Icon(p['icon'] as IconData),
              selectedIcon: Icon(p['selectedIcon'] as IconData),
              label: Text(p['label'] as String),
            ))
        .toList();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _getCharacterName() {
    final saveData = ref.watch(saveDataProvider).data;
    if (saveData == null) return "加载中...";
    try {
      return saveData['callname'][widget.characterId.toString()]['-1'] ??
          '未知角色';
    } catch (e) {
      return '未知角色';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Platform-specific UI
    if (!kIsWeb && Platform.isWindows) {
      return _buildWindowsLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  Widget _buildWindowsLayout() {
    final characterName = _getCharacterName();
    return Scaffold(
      appBar: AppBar(
        title: Text('正在编辑 $characterName'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemTapped,
            labelType: NavigationRailLabelType.all,
            destinations: _railDestinations,
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

  Widget _buildMobileLayout() {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    final characterName = _getCharacterName();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text('正在编辑 $characterName'),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
              ),
            ),
          ];
        },
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: KeyedSubtree(
            key: ValueKey<int>(_selectedIndex),
            child: _pages[_selectedIndex],
          ),
        ),
      ),
      bottomNavigationBar: isKeyboardVisible
          ? null
          : NavigationBar(
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              destinations: _destinations,
            ),
    );
  }
}
