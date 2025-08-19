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
    EditorItem(label: '当前回合数', jsonPath: 'flag/0', dataType: DataType.int),
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
    EditorItem.header('难度选项'),
    EditorItem(
        label: '训练难度',
        jsonPath: 'flag/100',
        dataType: DataType.choice,
        choices: [
          EditorChoice(25, "低"),
          EditorChoice(0, "中"),
          EditorChoice(-25, "高"),
        ],
        layoutType: LayoutType.double,
        description: '成功率加成'),
    EditorItem(
      label: '训练效果',
      jsonPath: 'flag/101',
      dataType: DataType.choice,
      choices: [
        EditorChoice(25, "好"),
        EditorChoice(0, "正常"),
        EditorChoice(-25, "差"),
      ],
      layoutType: LayoutType.double,
      description: '训练效果加成，提高属性上升量，降低属性下降量',
    ),
    EditorItem(
      label: '比赛难度',
      jsonPath: 'flag/102',
      dataType: DataType.choice,
      choices: [
        EditorChoice(-40, "低"),
        EditorChoice(0, "正常"),
        EditorChoice(10, "高"),
      ],
      layoutType: LayoutType.double,
      description: '对手属性加成',
    ),
    EditorItem(
      label: '道具价格',
      jsonPath: 'flag/119',
      dataType: DataType.choice,
      choices: [
        EditorChoice(-50, "乐善好施"),
        EditorChoice(0, "循规蹈矩"),
        EditorChoice(100, "奸诈狡猾"),
      ],
      layoutType: LayoutType.double,
      description: '商店的经营者',
    ),
    EditorItem(
      label: '马娘初始好感',
      jsonPath: 'flag/104',
      dataType: DataType.choice,
      choices: [
        EditorChoice(-100, "失望"),
        EditorChoice(0, "怀疑"),
        EditorChoice(75, "冷淡"),
        EditorChoice(150, "融洽"),
        EditorChoice(225, "热忱"),
      ],
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '马娘初始爱慕',
      jsonPath: 'flag/105',
      dataType: DataType.choice,
      choices: [
        EditorChoice(0, "平常"),
        EditorChoice(25, "暧昧"),
        EditorChoice(50, "爱欲"),
      ],
      layoutType: LayoutType.double,
    ),
    EditorItem(
        label: '好感提升难度',
        jsonPath: 'flag/106',
        dataType: DataType.choice,
        choices: [
          EditorChoice(50, "容易"),
          EditorChoice(0, "一般"),
          EditorChoice(-50, "困难"),
        ],
        layoutType: LayoutType.double,
        description: '提高好感上升量，降低好感下降量'),
    EditorItem(
      label: '爱慕提升难度',
      jsonPath: 'flag/107',
      dataType: DataType.choice,
      choices: [
        EditorChoice(0, "一般"),
        EditorChoice(50, "容易"),
      ],
      layoutType: LayoutType.double,
      description: '提高爱慕上升量',
    ),
    EditorItem(
      label: '回合好感变化',
      jsonPath: 'flag/112',
      dataType: DataType.choice,
      choices: [
        EditorChoice(-10, "相看相厌"),
        EditorChoice(0, "君子之交"),
        EditorChoice(5, "愈久愈和"),
      ],
      layoutType: LayoutType.double,
      description: '过回合时马娘的好感度',
    ),
    EditorItem(
      label: '回合声望变化',
      jsonPath: 'flag/111',
      dataType: DataType.choice,
      choices: [
        EditorChoice(-1, "逐渐衰减"),
        EditorChoice(0, "不增不减"),
        EditorChoice(1, "与日俱增"),
      ],
      layoutType: LayoutType.double,
      description: '过回合时声望变动',
    ),
    EditorItem(
      label: '对出轨的看法(不忠惩罚)',
      jsonPath: 'flag/126',
      dataType: DataType.choice,
      choices: [
        EditorChoice(0, "心胸开阔"),
        EditorChoice(1, "不可原谅"),
      ],
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '极端行为限制',
      jsonPath: 'flag/110',
      dataType: DataType.choice,
      choices: [
        EditorChoice(0, "不会进行"),
        EditorChoice(1, "有可能"),
        EditorChoice(2, "尽量抑制"),
        EditorChoice(3, "积极采取"),
      ],
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '马娘可能受伤',
      jsonPath: 'flag/103',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '马娘承受压力',
      jsonPath: 'flag/125',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '性技自主学习',
      jsonPath: 'flag/108',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
        label: '自带钝感',
        jsonPath: 'flag/117',
        dataType: DataType.boolean,
        layoutType: LayoutType.double,
        description: '是否自带全部位钝感'),
    EditorItem(
      label: '强奸抵抗',
      jsonPath: 'flag/122',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
        label: '不伦之恋',
        jsonPath: 'flag/115',
        dataType: DataType.boolean,
        layoutType: LayoutType.double,
        description: '新生角色是否会主动发起爱慕关系'),
    EditorItem(
      label: '角色性别',
      jsonPath: 'flag/116',
      dataType: DataType.choice,
      choices: [
        EditorChoice(0, "群芳环绕"),
        EditorChoice(1, "阳刚爆表"),
        EditorChoice(10, "阴阳并济"),
        EditorChoice(99, "现实投射"),
      ],
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '天生特性',
      jsonPath: 'flag/118',
      dataType: DataType.choice,
      choices: [
        EditorChoice(-4, "与性无缘"),
        EditorChoice(-1, "冰清玉洁"),
        EditorChoice(0, "听天由命"),
        EditorChoice(1, "淫娃荡妇"),
      ],
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '马娘身高',
      jsonPath: 'flag/109',
      dataType: DataType.choice,
      choices: [
        EditorChoice(0, "萝莉"),
        EditorChoice(1, "正常"),
        EditorChoice(2, "巨大"),
      ],
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '身败名裂时',
      jsonPath: 'flag/124',
      dataType: DataType.choice,
      choices: [
        EditorChoice(0, "黯然退场"),
        EditorChoice(1, "黑暗交易"),
      ],
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '回合爱慕变化',
      jsonPath: 'flag/113',
      dataType: DataType.choice,
      choices: [
        EditorChoice(0, "不敢肖想"),
        EditorChoice(1, "逐渐吸引"),
      ],
      layoutType: LayoutType.double,
      description: '过回合时马娘的爱慕',
    ),
    EditorItem(
      label: '游戏结束',
      jsonPath: 'flag/114',
      dataType: DataType.choice,
      choices: [
        EditorChoice(0, "不散筵席"),
        EditorChoice(1, "+粉丝袭击"),
        EditorChoice(2, "+金钱奴隶"),
        EditorChoice(3, "+情爱囹圄"),
      ],
      layoutType: LayoutType.double,
      description: '游戏结束条件',
    ),
    EditorItem(
      label: '目白城风格',
      jsonPath: 'flag/37',
      dataType: DataType.choice,
      choices: [
        EditorChoice(0, "自由"),
        EditorChoice(1, "慈爱"),
      ],
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '道具影响',
      jsonPath: 'flag/123',
      dataType: DataType.choice,
      choices: [
        EditorChoice(-25, "寸步难行"),
        EditorChoice(0, "负重冲锋"),
      ],
      layoutType: LayoutType.double,
      description: '调教道具对属性的影响',
    ),
    EditorItem(
      label: '宝珠消耗量',
      jsonPath: 'flag/120',
      dataType: DataType.choice,
      choices: [
        EditorChoice(-50, "低"),
        EditorChoice(0, "一般"),
        EditorChoice(100, "高"),
      ],
      layoutType: LayoutType.double,
      description: '宝珠购买的项目价格',
    ),
    EditorItem(
      label: '因子消耗量',
      jsonPath: 'flag/121',
      dataType: DataType.choice,
      choices: [
        EditorChoice(-50, "低"),
        EditorChoice(0, "一般"),
        EditorChoice(100, "高"),
      ],
      layoutType: LayoutType.double,
      description: '因子购买的项目价格',
    ),
    EditorItem.header('其余选项'),
    EditorItem(
      label: '筛除训练室活动',
      jsonPath: 'flag/60',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '筛除外出活动',
      jsonPath: 'flag/61',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '筛除樱花赏指令',
      jsonPath: 'flag/70',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '筛除菊花赏指令',
      jsonPath: 'flag/71',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem.header('性爱开关'),
    EditorItem(
      label: '筛除sm指令',
      jsonPath: 'flag/72',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '筛除爱抚指令',
      jsonPath: 'flag/73',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '筛除零奶乳交',
      jsonPath: 'flag/74',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '筛除请求指令',
      jsonPath: 'flag/75',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '筛除强制指令',
      jsonPath: 'flag/76',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '马跳结果显示简报',
      jsonPath: 'flag/77',
      dataType: DataType.boolean,
      layoutType: LayoutType.double,
    ),
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
