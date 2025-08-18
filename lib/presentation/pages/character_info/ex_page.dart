import 'package:era_uma_editor/config/constants.dart';
import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:era_uma_editor/presentation/widgets/editor_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExPage extends ConsumerStatefulWidget {
  final int characterId;
  const ExPage({super.key, required this.characterId});

  @override
  ConsumerState<ExPage> createState() => _ExPageState();
}

class _ExPageState extends ConsumerState<ExPage> {
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
      if (data['ex'] == null || data['ex'][charId.toString()] == null) {
        return [EditorItem.header('无经历数据')];
      }
      final exMap = data['ex'][charId.toString()] as Map<String, dynamic>;
      final sortedKeys = exMap.keys.toList()
        ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      for (var key in sortedKeys) {
        final exName = Constants.EX_MAP[key] ?? '未知状态 $key';
        items.add(
          EditorItem(
            label: exName,
            jsonPath: 'ex/{id}/$key',
            dataType: DataType.boolean,
            layoutType: LayoutType.double,
          ),
        );
      }
    } catch (e) {
      return [EditorItem.header('无法加载状态数据')];
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
