import 'package:era_uma_editor/config/constants.dart';
import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:era_uma_editor/presentation/widgets/editor_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AbilityPage extends ConsumerStatefulWidget {
  final int characterId;
  const AbilityPage({super.key, required this.characterId});

  @override
  ConsumerState<AbilityPage> createState() => _AbilityPageState();
}

class _AbilityPageState extends ConsumerState<AbilityPage> {
  late final List<EditorItem> _items;

  @override
  void initState() {
    super.initState();
    final data = ref.read(saveDataProvider).data;
    _items = _buildItems(data, widget.characterId);
  }

  List<EditorItem> _buildItems(Map<String, dynamic>? data, int charId) {
    if (data == null) return [];
    final List<EditorItem> items = [];
    try {
      if (data['abl'] == null || data['abl'][charId.toString()] == null) {
        return [EditorItem.header('无能力数据')];
      }
      final ablMap = data['abl'][charId.toString()] as Map<String, dynamic>;
      final sortedKeys = ablMap.keys.toList()
        ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      for (var key in sortedKeys) {
        if (int.tryParse(key) == 7) {
          items.add(EditorItem.header('性爱等级'));
        }
        final ablName = Constants.ABL_MAP[key] ?? '未知能力 $key';
        items.add(
          EditorItem(
            label: ablName,
            jsonPath: 'abl/{id}/$key',
            dataType: DataType.int,
            layoutType: LayoutType.double,
            suffix: '级',
          ),
        );
      }
    } catch (e) {
      return [EditorItem.header('无法加载能力数据')];
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final saveData = ref.watch(saveDataProvider).data;
    if (saveData == null) {
      return const Center(child: Text('存档未加载'));
    }
    return EditorItemList(
      items: _items,
      asSliver: false,
      characterId: widget.characterId,
    );
  }
}
