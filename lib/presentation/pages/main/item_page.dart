import 'package:era_uma_editor/config/constants.dart';
import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:era_uma_editor/presentation/widgets/editor_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ItemPage extends ConsumerWidget {
  const ItemPage({super.key});

  List<EditorItem> _buildItems(Map<String, dynamic>? data) {
    if (data == null) return [];

    final List<EditorItem> items = [];
    try {
      final itemHold = data['item']['hold'] as Map<String, dynamic>;
      final sortedKeys = itemHold.keys.toList()
        ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

      for (var key in sortedKeys) {
        final itemName = Constants.ITEM_MAP[key] ?? '未知物品 $key';
        items.add(
          EditorItem(
            label: itemName,
            jsonPath: 'item/hold/$key',
            dataType: DataType.int,
            layoutType: LayoutType.double,
            suffix: '个',
          ),
        );
      }
    } catch (e) {
      return [EditorItem.header('无法加载物品数据')];
    }
    return items;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveData = ref.watch(saveDataProvider).data;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('持有物品'), floating: true, snap: true),
          if (saveData == null)
            const SliverFillRemaining(child: Center(child: Text('请先加载一个存档文件')))
          else
            EditorItemList(items: _buildItems(saveData), characterId: 0),
        ],
      ),
    );
  }
}
