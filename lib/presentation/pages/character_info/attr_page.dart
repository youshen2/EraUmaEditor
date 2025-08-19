import 'package:era_uma_editor/config/constants.dart';
import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:era_uma_editor/presentation/widgets/editor_item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttrPage extends ConsumerStatefulWidget {
  final int characterId;
  const AttrPage({super.key, required this.characterId});

  @override
  ConsumerState<AttrPage> createState() => _AttrPageState();
}

class _AttrPageState extends ConsumerState<AttrPage> {
  static final List<EditorChoice> _aptitudeChoices = [
    EditorChoice(0, "G"),
    EditorChoice(1, "F"),
    EditorChoice(2, "E"),
    EditorChoice(3, "D"),
    EditorChoice(4, "C"),
    EditorChoice(5, "B"),
    EditorChoice(6, "A"),
    EditorChoice(7, "S"),
  ];

  List<EditorItem> _buildItems(Map<String, dynamic>? data, int charId) {
    if (data == null) return [];

    final List<EditorItem> allPossibleItems = [
      EditorItem.info("人类无法被育成，如果你想体验修改器的力量、对人类进行育成，请到下方“角色信息”中将种族修改为“马娘”。"),
      EditorItem.header("事件相关"),
      EditorItem(
        label: '招募状态',
        jsonPath: 'cflag/{id}/66',
        dataType: DataType.choice,
        choices: [
          EditorChoice(-1, '剧情角色'),
          EditorChoice(0, '未招募'),
          EditorChoice(1, '已招募'),
        ],
        description: "决定角色是否在队伍中",
        layoutType: LayoutType.double,
      ),
      EditorItem(
          label: '年龄',
          jsonPath: 'cflag/{id}/65',
          dataType: DataType.choice,
          choices: [
            EditorChoice(0, '幼年期'),
            EditorChoice(1, '成长期'),
            EditorChoice(2, '本格期（2）'),
            EditorChoice(3, '本格期（3）'),
            EditorChoice(4, '本格期（4）'),
            EditorChoice(5, '本格期（5）'),
          ],
          layoutType: LayoutType.double),
      EditorItem(
          label: '育成次数', jsonPath: 'cflag/{id}/48', dataType: DataType.int),
      EditorItem.info("如果无法进行育成，请将育成次数改为1或0。"),
      EditorItem(
        label: '殿堂',
        jsonPath: 'cflag/{id}/47',
        dataType: DataType.boolean,
        layoutType: LayoutType.double,
        description: '停止育成，无法训练、比赛等',
      ),
      EditorItem(
          label: '可再次育成',
          jsonPath: 'cflag/{id}/50',
          dataType: DataType.boolean,
          layoutType: LayoutType.double),
      EditorItem.header('基础数值'),
      EditorItem.info("如果你修改的是训练员，请注意：训练员的精力和体力只会在当前回合生效。"),
      EditorItem(
          label: '体力',
          jsonPath: 'base/{id}/0',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '最大体力',
          jsonPath: 'maxbase/{id}/0',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '精力',
          jsonPath: 'base/{id}/1',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '最大精力',
          jsonPath: 'maxbase/{id}/1',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem.header('基础属性'),
      EditorItem(
          label: '速度',
          jsonPath: 'base/{id}/5',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '最大速度',
          jsonPath: 'maxbase/{id}/5',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '耐力',
          jsonPath: 'base/{id}/6',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '最大耐力',
          jsonPath: 'maxbase/{id}/6',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '力量',
          jsonPath: 'base/{id}/7',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '最大力量',
          jsonPath: 'maxbase/{id}/7',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '根性',
          jsonPath: 'base/{id}/8',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '最大根性',
          jsonPath: 'maxbase/{id}/8',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '智力',
          jsonPath: 'base/{id}/9',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '最大智力',
          jsonPath: 'maxbase/{id}/9',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
        label: '干劲',
        jsonPath: 'cflag/{id}/40',
        dataType: DataType.choice,
        choices: [
          EditorChoice(-2, "极差"),
          EditorChoice(-1, "较差"),
          EditorChoice(0, "一般"),
          EditorChoice(1, "较佳"),
          EditorChoice(2, "极佳"),
        ],
      ),
      EditorItem.header('隐藏属性'),
      EditorItem(
          label: '性欲',
          jsonPath: 'base/{id}/10',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '最大性欲',
          jsonPath: 'maxbase/{id}/10',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '压力',
          jsonPath: 'base/{id}/11',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '最大压力',
          jsonPath: 'maxbase/{id}/11',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '体重偏差',
          jsonPath: 'base/{id}/12',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem(
          label: '药物残留',
          jsonPath: 'base/{id}/13',
          dataType: DataType.float,
          layoutType: LayoutType.double),
      EditorItem.header('关系数值'),
      EditorItem(
          label: '好感度',
          jsonPath: 'relation/{id}/0',
          dataType: DataType.int,
          layoutType: LayoutType.double),
      EditorItem(
          label: '爱慕',
          jsonPath: 'love/{id}',
          dataType: DataType.int,
          layoutType: LayoutType.double),
      EditorItem.header('适应性'),
      EditorItem(
          label: '草地',
          jsonPath: 'cflag/{id}/30',
          dataType: DataType.choice,
          layoutType: LayoutType.double,
          choices: _aptitudeChoices),
      EditorItem(
          label: '泥地',
          jsonPath: 'cflag/{id}/31',
          dataType: DataType.choice,
          layoutType: LayoutType.double,
          choices: _aptitudeChoices),
      EditorItem(
          label: '短距离',
          jsonPath: 'cflag/{id}/32',
          dataType: DataType.choice,
          layoutType: LayoutType.double,
          choices: _aptitudeChoices),
      EditorItem(
          label: '英里',
          jsonPath: 'cflag/{id}/33',
          dataType: DataType.choice,
          layoutType: LayoutType.double,
          choices: _aptitudeChoices),
      EditorItem(
          label: '中距离',
          jsonPath: 'cflag/{id}/34',
          dataType: DataType.choice,
          layoutType: LayoutType.double,
          choices: _aptitudeChoices),
      EditorItem(
          label: '长距离',
          jsonPath: 'cflag/{id}/35',
          dataType: DataType.choice,
          layoutType: LayoutType.double,
          choices: _aptitudeChoices),
      EditorItem(
          label: '逃马',
          jsonPath: 'cflag/{id}/36',
          dataType: DataType.choice,
          layoutType: LayoutType.double,
          choices: _aptitudeChoices),
      EditorItem(
          label: '先马',
          jsonPath: 'cflag/{id}/37',
          dataType: DataType.choice,
          layoutType: LayoutType.double,
          choices: _aptitudeChoices),
      EditorItem(
          label: '差马',
          jsonPath: 'cflag/{id}/38',
          dataType: DataType.choice,
          layoutType: LayoutType.double,
          choices: _aptitudeChoices),
      EditorItem(
          label: '追马',
          jsonPath: 'cflag/{id}/39',
          dataType: DataType.choice,
          layoutType: LayoutType.double,
          choices: _aptitudeChoices),
      EditorItem.header('角色信息'),
      EditorItem(
          label: '性别',
          jsonPath: 'cflag/{id}/0',
          dataType: DataType.choice,
          choices: [
            EditorChoice(0, "女性"),
            EditorChoice(1, "男性"),
            EditorChoice(2, "扶她"),
          ],
          layoutType: LayoutType.double),
      EditorItem(
          label: '种族',
          jsonPath: 'cflag/{id}/1',
          dataType: DataType.choice,
          choices: [
            EditorChoice(0, '人类'),
            EditorChoice(1, '马娘'),
          ],
          layoutType: LayoutType.double),
      EditorItem(
        label: '气性',
        jsonPath: 'cflag/{id}/2',
        dataType: DataType.choice,
        choices: [
          EditorChoice(-3, '顺从'),
          EditorChoice(-2, '担心'),
          EditorChoice(-1, '认真'),
          EditorChoice(0, '普通'),
          EditorChoice(1, '要强'),
          EditorChoice(2, '顽固'),
          EditorChoice(3, '热血'),
        ],
      ),
      EditorItem(
        label: '阴茎尺寸',
        jsonPath: 'cflag/{id}/4',
        dataType: DataType.choice,
        choices: [
          EditorChoice(1, "可怜"),
          EditorChoice(2, "寒酸"),
          EditorChoice(3, "健壮"),
          EditorChoice(4, "凶恶"),
          EditorChoice(5, "骇人"),
        ],
        conditions: [
          EditorItemCondition(
              jsonPath: 'cflag/{id}/0', value: 0, isEqual: false),
        ],
      ),
      EditorItem(
        label: '下胸围',
        jsonPath: 'cflag/{id}/3',
        dataType: DataType.float,
        description: '大于200为胸部，其他为乳房',
        conditions: [
          EditorItemCondition(jsonPath: 'cflag/{id}/0', value: 0),
        ],
      ),
      EditorItem(
        label: '身高',
        jsonPath: 'cflag/{id}/6',
        dataType: DataType.float,
        layoutType: LayoutType.double,
      ),
      EditorItem(
        label: '胸围',
        jsonPath: 'cflag/{id}/7',
        dataType: DataType.float,
        layoutType: LayoutType.double,
      ),
      EditorItem(
        label: '腰围',
        jsonPath: 'cflag/{id}/8',
        dataType: DataType.float,
        layoutType: LayoutType.double,
      ),
      EditorItem(
        label: '臀围',
        jsonPath: 'cflag/{id}/9',
        dataType: DataType.float,
        layoutType: LayoutType.double,
      ),
      EditorItem(
        label: '肤色深度',
        jsonPath: 'cflag/{id}/10',
        dataType: DataType.choice,
        choices: [
          EditorChoice(-1, "偏短"),
          EditorChoice(0, "正常"),
          EditorChoice(1, "偏深"),
          EditorChoice(2, "小麦色"),
        ],
        layoutType: LayoutType.double,
      ),
      EditorItem(
        label: '头发长度',
        jsonPath: 'cflag/{id}/11',
        dataType: DataType.choice,
        choices: [
          EditorChoice(0, "短发"),
          EditorChoice(1, "齐肩"),
          EditorChoice(2, "齐腰"),
        ],
        layoutType: LayoutType.double,
      ),
      EditorItem(
        label: '流星大小',
        jsonPath: 'cflag/{id}/12',
        dataType: DataType.choice,
        choices: [
          EditorChoice(-2, "无"),
          EditorChoice(-1, "偏小"),
          EditorChoice(0, "普通"),
          EditorChoice(1, "偏大"),
          EditorChoice(2, "全长"),
        ],
      ),
      EditorItem(
        label: '腋毛',
        jsonPath: 'cflag/{id}/13',
        dataType: DataType.choice,
        choices: [
          EditorChoice(0, "光滑"),
          EditorChoice(1, "稀疏"),
          EditorChoice(2, "整齐"),
          EditorChoice(3, "浓密"),
          EditorChoice(4, "杂乱"),
          EditorChoice(5, "剛毛"),
        ],
        layoutType: LayoutType.double,
      ),
      EditorItem(
        label: '阴毛',
        jsonPath: 'cflag/{id}/14',
        dataType: DataType.choice,
        choices: [
          EditorChoice(0, "光滑"),
          EditorChoice(1, "稀疏"),
          EditorChoice(2, "整齐"),
          EditorChoice(3, "浓密"),
          EditorChoice(4, "杂乱"),
          EditorChoice(5, "剛毛"),
        ],
        layoutType: LayoutType.double,
      ),
      EditorItem.header('调教与后代相关'),
      EditorItem(
        label: '妊娠阶段',
        jsonPath: 'cflag/{id}/81',
        dataType: DataType.choice,
        choices: [
          EditorChoice(-1, "恢复期"),
          EditorChoice(0, "无"),
          EditorChoice(1, "孕早期"),
          EditorChoice(2, "安定期"),
          EditorChoice(3, "孕晚期"),
          EditorChoice(4, "临产"),
        ],
        layoutType: LayoutType.double,
      ),
      EditorItem(
        label: '妊娠回合计时',
        jsonPath: 'cflag/{id}/82',
        dataType: DataType.int,
        layoutType: LayoutType.double,
        description: '1~6=早 7~14=安 15+=晚',
      ),
    ];

    try {
      final statusMap =
          data['status'][charId.toString()] as Map<String, dynamic>;
      if (statusMap.isNotEmpty) {
        allPossibleItems.add(EditorItem.header('当前状态（会被重置）'));

        final sortedKeys = statusMap.keys.toList()
          ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

        for (var key in sortedKeys) {
          final statusName = Constants.STATUS_MAP[key] ?? '未知状态 $key';
          final statusDesc = Constants.STATUS_DESC_MAP[key] ?? '';
          final isShow = !Constants.STATUS_CID_MAP.containsKey(key) ||
              Constants.STATUS_CID_MAP[key] == charId;
          if (isShow) {
            allPossibleItems.add(
              EditorItem(
                label: statusName,
                jsonPath: 'status/{id}/$key',
                dataType: DataType.boolean,
                layoutType: LayoutType.double,
                description: statusDesc,
              ),
            );
          }
          if (int.tryParse(key) == 26) {
            allPossibleItems.add(EditorItem.header('床技相关'));
          } else if (int.tryParse(key) == 42) {
            allPossibleItems.add(EditorItem.header('角色专属'));
          }
        }
      }
    } catch (e) {
      // NULL
    }
    return allPossibleItems;
  }

  @override
  Widget build(BuildContext context) {
    final saveData = ref.watch(saveDataProvider).data;
    if (saveData == null) {
      return const Center(child: Text('存档未加载'));
    }
    final items = _buildItems(saveData, widget.characterId);
    return EditorItemList(
      items: items,
      asSliver: false,
      characterId: widget.characterId,
    );
  }
}
