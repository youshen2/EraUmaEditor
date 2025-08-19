import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:era_uma_editor/utils/json_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DropdownItem extends ConsumerWidget {
  final EditorItem item;
  final int characterId;
  final bool isEnabled;

  const DropdownItem({
    super.key,
    required this.item,
    required this.characterId,
    required this.isEnabled,
  });

  Future<bool> _showWarningDialog(BuildContext context, String message) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('警告'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('确认'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> _showForceModifyDialog(
      BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('强制修改'),
        content: const Text('此项在存档中不存在或无效。\n是否要强制进行修改？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('确认'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final notifier = ref.read(saveDataProvider.notifier);
      final path = item.jsonPath.replaceAll('{id}', characterId.toString());
      final defaultValue = item.choices?.first.value ?? 0;
      notifier.updateValue(path, defaultValue);
    }
  }

  Future<void> _onChanged(
      EditorChoice? newValue, BuildContext context, WidgetRef ref) async {
    if (newValue == null) return;

    final notifier = ref.read(saveDataProvider.notifier);
    final path = item.jsonPath.replaceAll('{id}', characterId.toString());

    bool shouldUpdate = true;
    if (item.warningMessage != null && context.mounted) {
      shouldUpdate = await _showWarningDialog(context, item.warningMessage!);
    }

    if (shouldUpdate) {
      notifier.updateValue(path, newValue.value);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = item.jsonPath.replaceAll('{id}', characterId.toString());

    final currentValue = ref.watch(saveDataProvider.select((s) {
      if (s.data == null) {
        return null;
      }
      return JsonHelper.get(s.data!, path, null);
    }));

    EditorChoice? selectedChoice;
    bool isValueInChoices = true;
    if (currentValue != null && item.choices != null) {
      try {
        selectedChoice = item.choices!.firstWhere(
          (c) => c.value == currentValue,
        );
      } catch (e) {
        isValueInChoices = false;
      }
    }

    return GestureDetector(
      onTap: !isEnabled ? () => _showForceModifyDialog(context, ref) : null,
      child: IgnorePointer(
        ignoring: !isEnabled,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<EditorChoice>(
              value: selectedChoice,
              hint: !isEnabled
                  ? const Text('N/A')
                  : !isValueInChoices
                      ? Text(
                          '无效值: $currentValue',
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
              decoration: InputDecoration(
                labelText: item.label,
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                enabled: isEnabled,
              ),
              isExpanded: true,
              items: item.choices?.map((EditorChoice choice) {
                return DropdownMenuItem<EditorChoice>(
                  value: choice,
                  child: Text(choice.displayName),
                );
              }).toList(),
              onChanged: isEnabled && isValueInChoices
                  ? (EditorChoice? newValue) =>
                      _onChanged(newValue, context, ref)
                  : null,
            ),
            if (item.description != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                child: Text(
                  item.description!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
