# EraUma 存档编辑器

一个使用 Flutter 构建的 EraUma 存档编辑器。

此项目为原生安卓版的Flutter重写，并提供了跨平台支持（Windows, Android, iOS）。

点个Star吧喵~

## 构建

1.  安装 [Flutter SDK](https://flutter.dev/docs/get-started/install)。
2.  克隆仓库
    `git clone https://github.com/youshen2/EraUmaEditor.git`
3.  进入项目目录
4.  拉取依赖
    `flutter pub get`
5.  运行应用
    `flutter run`

## 开发指南

本项目中用于编辑属性的所有UI（如属性、能力、经验等页面）都是基于一个名为 `EditorItem` 的数据模型**动态生成**的。

`EditorItem` 定义了一个可编辑字段的所有信息：包括它的**标签文本**、**数据类型（决定了使用哪种输入控件）**，以及它在存档 JSON 文件中的**读写路径**。

这种方法使得添加、删除或修改编辑字段变得非常简单，只需要修改 `EditorItem` 的列表，而无需编写复杂的 UI 代码。

### `EditorItem` 参数

`EditorItem` 的主要构造函数包含以下关键参数：

-   `label` (String): 显示在输入控件旁边的文本，例如“体力”、“速度”。
-   `jsonPath` (String): **最关键的属性**。它指定了数据在存档文件的 JSON 对象中的路径。
    -   路径中的 `{id}` 占位符会在运行时被自动替换为当前角色的 ID。例如，`base/{id}/0` 对于 ID 为 `1001` 的角色，会被解析为 `base/1001/0`。
-   `dataType` (DataType): `enum` 类型，决定了数据类型和对应的输入控件。
-   `layoutType` (LayoutType): `enum` 类型，控制布局。
-   `choices` (List<EditorChoice>): 当 `dataType` 为 `DataType.choice` 时，此列表为必填项。
-   `warningMessage` (String?): (可选) 在修改此项数据前，会弹出一个警告对话框，向用户显示此消息以供确认。
-   `booleanRepresentation` (BooleanRepresentation): (可选) 当 `dataType` 为 `DataType.boolean` 时，指定布尔值在 JSON 中的存储方式。默认为 `BooleanRepresentation.asInt`（`1` 代表 `true`，`0` 代表 `false`）。可以设置为 `BooleanRepresentation.asBoolean` 来使用 `true`/`false`。
-   `conditions` (List<EditorItemCondition>?): (可选) 定义此项显示的条件。

### 创建输入控件

#### 数值输入 (`DataType.int`, `DataType.float`)

用于编辑数字，如体力、能力值等。它会生成一个文本框，并自动处理数字的解析和格式化。

```dart
EditorItem(
  label: '体力',
  jsonPath: 'base/{id}/0',
  dataType: DataType.float,
)
```

#### 开关 (`DataType.boolean`)

用于编辑布尔值，在界面上显示为一个开关 (Switch)。存档中的 `1` 会被视为 `true`，`0` 或其他值视为 `false`。

```dart
EditorItem(
  label: '初次接吻',
  jsonPath: 'ex/{id}/0',
  dataType: DataType.boolean,
)
```

#### 选择 (`DataType.choice`)

用于值必须是几个预定义选项之一的情况，例如“干劲”、“性别”等。它会生成一个下拉选择框。

-   它必须提供一个 `choices` 列表。
-   `EditorChoice` 接收两个参数：`value` (存储在 JSON 中的实际值) 和 `displayName` (显示在下拉框中的文本)。

```dart
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
)
```

#### 文本 (`DataType.string`)

用于编辑自由文本，例如角色的称呼。

```dart
EditorItem(
  label: '昵称',
  jsonPath: 'callname/{id}/-1',
  dataType: DataType.string,
)
```

### 想要高级一些？

#### 调整布局 (`layoutType`)

`layoutType` 属性可以控制项目的排列方式。`LayoutType.double` 能将两个项目并排显示在一个两列的网格中，非常适合“当前值/最大值”这样的配对。

要使用它，只需连续为两个 `EditorItem` 设置 `layoutType: LayoutType.double`。

```dart
EditorItem(
  label: '体力',
  jsonPath: 'base/{id}/0',
  dataType: DataType.float,
  layoutType: LayoutType.double, // 此项将成为网格的一部分
),
EditorItem(
  label: '最大体力',
  jsonPath: 'maxbase/{id}/0',
  dataType: DataType.float,
  layoutType: LayoutType.double, // 此项将显示在“体力”旁边
),
```

#### 添加修改警告 (`warningMessage`)

对于一些敏感数据，直接修改可能会导致游戏逻辑错误。
你可以通过设置 `warningMessage` 参数，在用户尝试修改该数据时弹出一个确认对话框。

```dart
EditorItem(
  label: '当前回合数',
  jsonPath: 'flag/0',
  dataType: DataType.int,
  description: '时间回溯！',
  warningMessage: '修改当前回合数可能会导致游戏事件错乱，确定要修改吗？'
),
```

#### 条件显示字段 (`conditions`)

`EditorItem` 支持一个 `conditions` 参数。这允许一个编辑控件仅在满足特定条件时才显示。

`EditorItemCondition` 类包含以下字段：
- `jsonPath`: `String` - 指向存档数据中需要检查的路径。
- `value`: `dynamic` - 用于与 `jsonPath` 的值进行比较的值。
- `isEqual`: `boolean` - (可选, 默认为 `true`) 用于表示值应该“等于” (`true`) 还是“不等于” (`false`)。

一个 `EditorItem` 可以有多个 `EditorItemCondition`。**所有条件都必须满足**，该 `EditorItem` 才会被渲染到屏幕上。

例如，我们只想在角色的性别**不为** "女性" (存档中 `cflag/{id}/0` 的值为 `0`) 时，才显示 "阴茎尺寸" 的编辑选项。

```dart
EditorItem(
  label: '阴茎尺寸',
  jsonPath: 'cflag/{id}/4',
  dataType: DataType.choice,
  choices: [ /* ... */ ],
  conditions: [
    // 仅当 cflag/{id}/0 的值不等于 0 时显示
    EditorItemCondition(jsonPath: 'cflag/{id}/0', value: 0, isEqual: false),
  ],
),
```
> `EditorItemList` 会自动处理这些条件，你无需在页面中编写任何额外的逻辑。

#### 强制修改不存在的数据

有时，存档文件中可能不存在某个 `jsonPath` 对应的数据（例如，一个新角色还没有某个经验值）。在这种情况下，对应的 UI 控件会显示为“无效”并被禁用。

用户可以**点击这个无效的控件**，此时会弹出一个对话框，询问是否要“强制添加”该项目。如果用户确认，该数据项会被赋予一个默认值（如 `0` 或空字符串）并添加到存档中，然后控件会变为可用状态，允许用户进行编辑。

### 完整示例

下面是一个如何在页面中定义 `EditorItem` 列表并使用 `EditorItemList` 控件来显示它们的完整示例。

```dart
import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/presentation/widgets/editor_item_list.dart';
import 'package:flutter/material.dart';

class MyCustomPage extends StatelessWidget {
  final int characterId; // 假设从外部传入当前角色ID
  const MyCustomPage({super.key, required this.characterId});

  // 1. 定义你的 EditorItem 列表
  final List<EditorItem> _items = const [
    EditorItem.header('基础数值'),
    EditorItem(
      label: '体力',
      jsonPath: 'base/{id}/0',
      dataType: DataType.float,
      layoutType: LayoutType.double,
    ),
    EditorItem(
      label: '最大体力',
      jsonPath: 'maxbase/{id}/0',
      dataType: DataType.float,
      layoutType: LayoutType.double,
    ),
    EditorItem.header('状态'),
    EditorItem(
      label: '已招募',
      jsonPath: 'cflag/{id}/66',
      dataType: DataType.boolean,
    ),
    EditorItem(
      label: '性别',
      jsonPath: 'cflag/{id}/0',
      dataType: DataType.choice,
      choices: [
        EditorChoice(0, "女性"),
        EditorChoice(1, "男性"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // 2. 将列表和角色ID传递给 EditorItemList 控件
    return EditorItemList(
      items: _items,
      characterId: characterId,
      // 如果 EditorItemList 直接作为 Scaffold 的 body，asSliver 为 false。
      // 如果它在 CustomScrollView -> Slivers 内部，则设为 true。
      asSliver: false, 
    );
  }
}
```

通过遵循以上模式，你可以轻松地为编辑器添加任何你想要的存档字段。