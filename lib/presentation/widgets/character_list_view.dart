import 'package:era_uma_editor/data/models/character_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CharacterListView extends ConsumerStatefulWidget {
  const CharacterListView({super.key});

  @override
  ConsumerState<CharacterListView> createState() => _CharacterListViewState();
}

class _CharacterListViewState extends ConsumerState<CharacterListView> {
  String _searchQuery = '';
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  List<CharacterItem> _getCharacterList(Map<String, dynamic>? data) {
    if (data == null || data['callname'] == null) {
      return [];
    }
    final List<CharacterItem> characters = [];
    try {
      final callnameMap = data['callname'] as Map<String, dynamic>;
      callnameMap.forEach((key, value) {
        if (value is Map<String, dynamic> && value.containsKey('-1')) {
          characters.add(CharacterItem(id: key, name: value['-1'].toString()));
        }
      });
      characters.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
    } catch (e) {
      // NULL
    }
    return characters;
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (_isSearchVisible) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        _searchQuery = '';
        _searchFocusNode.unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final saveData = ref.watch(saveDataProvider).data;
    final allCharacters = _getCharacterList(saveData);

    final filteredCharacters = _searchQuery.isEmpty
        ? allCharacters
        : allCharacters
            .where(
              (char) =>
                  char.name.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('角色数据'),
            floating: true,
            snap: true,
            actions: [
              if (saveData != null)
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _toggleSearch,
                ),
            ],
            automaticallyImplyLeading: false,
            bottom: _isSearchVisible
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        decoration: InputDecoration(
                          hintText: '搜索角色...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          contentPadding: EdgeInsets.zero,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: _toggleSearch,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
                    ),
                  )
                : null,
          ),
          if (saveData == null)
            const SliverFillRemaining(child: Center(child: Text('请先加载一个存档文件')))
          else
            SliverPadding(
              padding: const EdgeInsets.all(8.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final character = filteredCharacters[index];
                    return Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                            color: Theme.of(context).colorScheme.outlineVariant,
                            width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: Text(character.name),
                        onTap: () {
                          context.push('/character/${character.id}');
                        },
                      ),
                    );
                  },
                  childCount: filteredCharacters.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
