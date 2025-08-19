import 'package:era_uma_editor/data/models/character_item.dart';
import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:era_uma_editor/presentation/widgets/editor_items/text_field_item.dart';
import 'package:era_uma_editor/utils/json_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CallnamePage extends ConsumerStatefulWidget {
  final int characterId;
  const CallnamePage({super.key, required this.characterId});

  @override
  ConsumerState<CallnamePage> createState() => _CallnamePageState();
}

class _CallnamePageState extends ConsumerState<CallnamePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _showAddCallnameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return _AddCallnameDialog(currentCharId: widget.characterId);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final saveData = ref.watch(saveDataProvider).data;
    final charId = widget.characterId;
    final notifier = ref.read(saveDataProvider.notifier);

    if (saveData == null) {
      return const Center(child: Text('存档未加载'));
    }

    List<MapEntry<String, String>> callnameEntries = [];
    try {
      final callnameMap =
          saveData['callname'][charId.toString()] as Map<String, dynamic>;
      final allCallnames = saveData['callname'] as Map<String, dynamic>;

      final sortedKeys = callnameMap.keys
          .where((key) => key != '-1' && key != '-2')
          .toList()
        ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      for (var key in sortedKeys) {
        String targetName = '角色 $key';
        try {
          targetName = allCallnames[key]['-1'] ?? targetName;
        } catch (_) {}

        callnameEntries.add(MapEntry(key, targetName));
      }
    } catch (e) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('无法加载称呼数据'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _showAddCallnameDialog,
              icon: const Icon(Icons.add),
              label: const Text('手动添加'),
            )
          ],
        ),
      );
    }

    return Stack(
      children: [
        Scrollbar(
          controller: _scrollController,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 80.0),
            itemCount: callnameEntries.length,
            itemBuilder: (context, index) {
              final entry = callnameEntries[index];
              final targetId = entry.key;
              final targetName = entry.value;
              final path = 'callname/$charId/$targetId';

              final item = EditorItem(
                label: '对 $targetName 的称呼',
                jsonPath: path,
                dataType: DataType.string,
              );

              final bool isEnabled =
                  JsonHelper.keyExists(saveData, path.replaceAll('/', '/'));

              return Padding(
                key: ValueKey(targetId),
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFieldItem(
                        item: item,
                        characterId: charId,
                        isEnabled: isEnabled,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        color: Theme.of(context).colorScheme.error,
                        tooltip: '删除此称呼',
                        onPressed: !isEnabled
                            ? null
                            : () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('确认删除'),
                                    content: Text('确定要删除对 $targetName 的称呼吗？'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: const Text('取消'),
                                      ),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                            foregroundColor: Theme.of(context)
                                                .colorScheme
                                                .error),
                                        onPressed: () {
                                          notifier.removeValue(path);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('删除'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _showAddCallnameDialog,
            tooltip: '添加称呼',
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}

class _AddCallnameDialog extends ConsumerStatefulWidget {
  final int currentCharId;
  const _AddCallnameDialog({required this.currentCharId});

  @override
  ConsumerState<_AddCallnameDialog> createState() => _AddCallnameDialogState();
}

class _AddCallnameDialogState extends ConsumerState<_AddCallnameDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  CharacterItem? _selectedCharacter;
  late List<CharacterItem> _characterList;

  @override
  void initState() {
    super.initState();
    final saveData = ref.read(saveDataProvider).data;
    _characterList = _getAvailableCharacters(saveData);
  }

  List<CharacterItem> _getAvailableCharacters(Map<String, dynamic>? data) {
    if (data == null) return [];

    final allCharacters = _getAllCharacters(data);

    Set<String> existingTargetIds = {};
    try {
      final currentCharacterCallnames = data['callname']
          ?[widget.currentCharId.toString()] as Map<String, dynamic>?;
      if (currentCharacterCallnames != null) {
        existingTargetIds = currentCharacterCallnames.keys.toSet();
      }
    } catch (e) {
      // NULL
    }

    existingTargetIds.add(widget.currentCharId.toString());

    return allCharacters
        .where((char) => !existingTargetIds.contains(char.id))
        .toList();
  }

  List<CharacterItem> _getAllCharacters(Map<String, dynamic>? data) {
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

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _addCallname() {
    if (_formKey.currentState!.validate()) {
      final notifier = ref.read(saveDataProvider.notifier);
      final path = 'callname/${widget.currentCharId}/${_selectedCharacter!.id}';
      notifier.updateValue(path, _nameController.text);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('添加称呼'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<CharacterItem>(
              value: _selectedCharacter,
              hint: const Text('选择目标角色'),
              isExpanded: true,
              items: _characterList.map((CharacterItem char) {
                return DropdownMenuItem<CharacterItem>(
                  value: char,
                  child: Text(
                    '${char.name} (ID: ${char.id})',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (CharacterItem? newValue) {
                setState(() {
                  _selectedCharacter = newValue;
                });
              },
              validator: (value) => value == null ? '请选择一个角色' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: '称呼'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '请输入称呼';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('取消'),
        ),
        TextButton(
          onPressed: _addCallname,
          child: const Text('添加'),
        ),
      ],
    );
  }
}
