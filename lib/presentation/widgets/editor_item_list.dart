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
    for (int i = 0; i < widget.items.length; i++) {
      final currentItem = widget.items[i];

      if (currentItem.dataType == DataType.header) {
        widgets.add(HeaderItem(item: currentItem));
        continue;
      }

      if (currentItem.layoutType == LayoutType.single) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: _buildSingleWidget(currentItem, saveData),
          ),
        );
        continue;
      }

      if (currentItem.layoutType == LayoutType.double) {
        final item1 = currentItem;
        final item2 = (i + 1 < widget.items.length &&
                widget.items[i + 1].layoutType == LayoutType.double &&
                widget.items[i + 1].dataType != DataType.header &&
                widget.items[i + 1].dataType != DataType.info)
            ? widget.items[i + 1]
            : null;

        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
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
