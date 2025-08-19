import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:era_uma_editor/presentation/widgets/editor_items/checkbox_item.dart';
import 'package:era_uma_editor/presentation/widgets/editor_items/dropdown_item.dart';
import 'package:era_uma_editor/presentation/widgets/editor_items/header_item.dart';
import 'package:era_uma_editor/presentation/widgets/editor_items/info_item.dart';
import 'package:era_uma_editor/presentation/widgets/editor_items/text_field_item.dart';
import 'package:era_uma_editor/utils/json_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditorItemList extends ConsumerStatefulWidget {
  final List<EditorItem> items;
  final bool asSliver;
  final int characterId;

  const EditorItemList({
    super.key,
    required this.items,
    this.asSliver = true,
    required this.characterId,
  });

  @override
  ConsumerState<EditorItemList> createState() => _EditorItemListState();
}

class _EditorItemListState extends ConsumerState<EditorItemList> {
  late final ScrollController _scrollController;
  final Map<String, bool> _collapsedStates = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _checkConditions(List<EditorItemCondition> conditions,
      Map<String, dynamic> data, int charId) {
    for (final condition in conditions) {
      final path = condition.jsonPath.replaceAll('{id}', charId.toString());
      final actualValue = JsonHelper.get(data, path, null);

      if ((actualValue == condition.value) != condition.isEqual) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final saveData = ref.watch(saveDataProvider).data;
    if (saveData == null) {
      return widget.asSliver
          ? const SliverToBoxAdapter(child: SizedBox.shrink())
          : const SizedBox.shrink();
    }

    final widgets = _buildWidgets(saveData);

    if (widget.asSliver) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => widgets[index],
            childCount: widgets.length,
          ),
        ),
      );
    } else {
      return Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          itemCount: widgets.length,
          itemBuilder: (context, index) {
            return widgets[index];
          },
        ),
      );
    }
  }

  List<Widget> _buildWidgets(Map<String, dynamic> saveData) {
    final List<Widget> widgets = [];

    final visibleItems = widget.items
        .where((item) =>
            item.conditions == null ||
            _checkConditions(item.conditions!, saveData, widget.characterId))
        .toList();

    for (int i = 0; i < visibleItems.length; i++) {
      final currentItem = visibleItems[i];

      if (currentItem.dataType == DataType.header) {
        final isCollapsed = _collapsedStates[currentItem.label] ?? false;
        widgets.add(HeaderItem(
          item: currentItem,
          isCollapsed: isCollapsed,
          onTap: () {
            setState(() {
              _collapsedStates[currentItem.label] = !isCollapsed;
            });
          },
        ));

        if (isCollapsed) {
          int nextHeaderIndex = -1;
          for (int j = i + 1; j < visibleItems.length; j++) {
            if (visibleItems[j].dataType == DataType.header) {
              nextHeaderIndex = j;
              break;
            }
          }
          if (nextHeaderIndex != -1) {
            i = nextHeaderIndex - 1;
          } else {
            i = visibleItems.length;
          }
        }
        continue;
      }

      final padding = EdgeInsets.symmetric(
          vertical: currentItem.description != null ? 8.0 : 6.0);

      if (currentItem.layoutType == LayoutType.single) {
        widgets.add(
          Padding(
            padding: padding,
            child: _buildSingleWidget(currentItem, saveData),
          ),
        );
        continue;
      }

      if (currentItem.layoutType == LayoutType.double) {
        final item1 = currentItem;
        final item2 = (i + 1 < visibleItems.length &&
                visibleItems[i + 1].layoutType == LayoutType.double &&
                visibleItems[i + 1].dataType != DataType.header &&
                visibleItems[i + 1].dataType != DataType.info)
            ? visibleItems[i + 1]
            : null;

        widgets.add(
          Padding(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildSingleWidget(item1, saveData)),
                const SizedBox(width: 8),
                Expanded(
                  child: item2 != null
                      ? _buildSingleWidget(item2, saveData)
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        );

        if (item2 != null) {
          i++;
        }
      }
    }
    return widgets;
  }

  Widget _buildSingleWidget(EditorItem item, Map<String, dynamic> saveData) {
    final path =
        item.jsonPath.replaceAll('{id}', widget.characterId.toString());
    final bool isEnabled =
        item.jsonPath.isEmpty || JsonHelper.keyExists(saveData, path);

    switch (item.dataType) {
      case DataType.int:
      case DataType.float:
      case DataType.string:
        return TextFieldItem(
            item: item, characterId: widget.characterId, isEnabled: isEnabled);
      case DataType.boolean:
        return CheckboxItem(
            item: item, characterId: widget.characterId, isEnabled: isEnabled);
      case DataType.choice:
        return DropdownItem(
            item: item, characterId: widget.characterId, isEnabled: isEnabled);
      case DataType.header:
        return HeaderItem(item: item);
      case DataType.info:
        return InfoItem(item: item);
    }
  }
}
