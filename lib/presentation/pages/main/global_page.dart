import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:era_uma_editor/presentation/widgets/editor_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalPage extends ConsumerWidget {
  const GlobalPage({super.key});

  static final List<EditorChoice> _onOffChoices = [
    EditorChoice(0, '关'),
    EditorChoice(1, '开')
  ];
  static final List<EditorChoice> _yesNoChoices = [
    EditorChoice(0, '否'),
    EditorChoice(1, '是')
  ];

  static final List<EditorItem> _items = [
    EditorItem(
        label: '当前声望',
        jsonPath: 'flag/15',
        dataType: DataType.int,
        layoutType: LayoutType.double),
    EditorItem(
        label: '当前马币',
        jsonPath: 'flag/16',
        dataType: DataType.int,
        layoutType: LayoutType.double),
    EditorItem(
        label: '当前回合数',
        jsonPath: 'flag/0',
        dataType: DataType.int,
        description: '时间回溯！'),
    EditorItem(label: '当前年份', jsonPath: 'flag/1', dataType: DataType.int),
    EditorItem(
        label: '当前月',
        jsonPath: 'flag/2',
        dataType: DataType.int,
        layoutType: LayoutType.double),
    EditorItem(
        label: '当前周',
        jsonPath: 'flag/3',
        dataType: DataType.int,
        layoutType: LayoutType.double,
        prefix: '第',
        suffix: '周'),
    EditorItem.header('基础开关'),
    EditorItem(
        label: '大舞台',
        jsonPath: 'flag/28',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _yesNoChoices),
    EditorItem(
        label: '强制BE',
        jsonPath: 'flag/27',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _yesNoChoices),
    EditorItem(
        label: '筛除训练室活动',
        jsonPath: 'flag/60',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '筛除外出活动',
        jsonPath: 'flag/61',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '筛除樱花赏指令',
        jsonPath: 'flag/70',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '筛除菊花赏指令',
        jsonPath: 'flag/71',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '读档对话',
        jsonPath: 'flag/127',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '彩蛋机制',
        jsonPath: 'flag/129',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem.header('养成开关'),
    EditorItem(
        label: '极端行为限制',
        jsonPath: 'flag/110',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '回合声望惩罚',
        jsonPath: 'flag/111',
        dataType: DataType.int,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '回合好感惩罚',
        jsonPath: 'flag/112',
        dataType: DataType.int,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '回合爱慕惩罚',
        jsonPath: 'flag/113',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '压力获取',
        jsonPath: 'flag/125',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '不忠惩罚',
        jsonPath: 'flag/126',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem.header('性爱开关'),
    EditorItem(
        label: '筛除sm指令',
        jsonPath: 'flag/72',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '筛除爱抚指令',
        jsonPath: 'flag/73',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '筛除零奶乳交',
        jsonPath: 'flag/74',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '筛除请求指令',
        jsonPath: 'flag/75',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '筛除强制指令',
        jsonPath: 'flag/76',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
    EditorItem(
        label: '马跳结果显示简报',
        jsonPath: 'flag/77',
        dataType: DataType.choice,
        layoutType: LayoutType.double,
        choices: _onOffChoices),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saveData = ref.watch(saveDataProvider).data;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
            title: Text('全局数据'),
            floating: true,
            snap: true,
          ),
          if (saveData == null)
            const SliverFillRemaining(
              child: Center(child: Text('请先加载一个存档文件')),
            )
          else
            EditorItemList(items: _items, characterId: 0),
        ],
      ),
    );
  }
}
