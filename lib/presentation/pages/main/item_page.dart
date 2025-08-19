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

      items.add(EditorItem.header('速子的小卖部'));
      for (var key in sortedKeys) {
        final itemName = Constants.ITEM_MAP[key] ?? '未知物品 $key';
        items.add(
          EditorItem(
            label: itemName,
            jsonPath: 'item/hold/$key',
            dataType: DataType.int,
            layoutType: LayoutType.double,
            suffix: '个',
            warningMessage: '部分物品存在最大值限制，超出最大值可能会坏档。',
          ),
        );
        if (int.tryParse(key) == 48) {
          items.add(EditorItem.header('车站 - 载具店'));
        } else if (int.tryParse(key) == 67) {
          items.add(EditorItem.header('神秘小店'));
        } else if (int.tryParse(key) == 85) {
          items.add(EditorItem.header('不贩卖的特殊道具'));
        } else if (int.tryParse(key) == 101) {
          items.add(EditorItem.header('不贩卖的特殊道具(爱丽速子)'));
        } else if (int.tryParse(key) == 105) {
          items.add(EditorItem.header('不贩卖的特殊道具(麦吉罗的呼唤)'));
        } else if (int.tryParse(key) == 111) {
          items.add(EditorItem.header('不贩卖的特殊道具(特殊载具)'));
        }
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
