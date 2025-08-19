import 'package:era_uma_editor/config/constants.dart';
import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:era_uma_editor/presentation/widgets/editor_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExpPage extends ConsumerStatefulWidget {
  final int characterId;
  const ExpPage({super.key, required this.characterId});

  @override
  ConsumerState<ExpPage> createState() => _ExpPageState();
}

class _ExpPageState extends ConsumerState<ExpPage> {
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
      if (data['exp'] == null || data['exp'][charId.toString()] == null) {
        return [EditorItem.header('无经验数据')];
      }
      final expMap = data['exp'][charId.toString()] as Map<String, dynamic>;
      final sortedKeys = expMap.keys.toList()
        ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      items.add(EditorItem.header('养马相关经验'));
      for (var key in sortedKeys) {
        final expName = Constants.EXP_MAP[key] ?? '未知经验 $key';
        items.add(
          EditorItem(
            label: expName,
            jsonPath: 'exp/{id}/$key',
            dataType: DataType.int,
            layoutType: LayoutType.double,
          ),
        );
        if (int.tryParse(key) == 19) {
          items.add(EditorItem.header('社交经历'));
        } else if (int.tryParse(key) == 20) {
          items.add(EditorItem.header('调教经历'));
        } else if (int.tryParse(key) == 28) {
          items.add(EditorItem.header('调教经历(口)'));
        } else if (int.tryParse(key) == 38) {
          items.add(EditorItem.header('调教经历(乳)'));
        } else if (int.tryParse(key) == 45) {
          items.add(EditorItem.header('调教经历(手)'));
        } else if (int.tryParse(key) == 54) {
          items.add(EditorItem.header('调教经历(足)'));
        } else if (int.tryParse(key) == 62) {
          items.add(EditorItem.header('调教经历(身)'));
        } else if (int.tryParse(key) == 72) {
          items.add(EditorItem.header('调教经历(菊)'));
        } else if (int.tryParse(key) == 83) {
          items.add(EditorItem.header('调教经历(虐)'));
        } else if (int.tryParse(key) == 95) {
          items.add(EditorItem.header('调教经历(茎)'));
        } else if (int.tryParse(key) == 107) {
          items.add(EditorItem.header('调教经历(膣)'));
        }
      }
    } catch (e) {
      return [EditorItem.header('无法加载经验数据')];
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
