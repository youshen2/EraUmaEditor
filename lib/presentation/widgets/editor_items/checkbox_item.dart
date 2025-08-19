import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:era_uma_editor/utils/json_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckboxItem extends ConsumerWidget {
  final EditorItem item;
  final int characterId;
  final bool isEnabled;

  const CheckboxItem({
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
      final defaultValue =
          item.booleanRepresentation == BooleanRepresentation.asBoolean
              ? false
              : 0;
      notifier.updateValue(path, defaultValue);
    }
  }

  Future<void> _onChanged(
      bool value, BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(saveDataProvider.notifier);
    final path = item.jsonPath.replaceAll('{id}', characterId.toString());

    bool shouldUpdate = true;
    if (item.warningMessage != null && context.mounted) {
      shouldUpdate = await _showWarningDialog(context, item.warningMessage!);
    }

    if (shouldUpdate) {
      dynamic valueToPut;
      if (item.booleanRepresentation == BooleanRepresentation.asInt) {
        valueToPut = value ? 1 : 0;
      } else {
        valueToPut = value;
      }
      notifier.updateValue(path, valueToPut);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = item.jsonPath.replaceAll('{id}', characterId.toString());

    final currentValue = ref.watch(saveDataProvider.select((s) {
      final defaultValue =
          item.booleanRepresentation == BooleanRepresentation.asBoolean
              ? false
              : 0;
      if (s.data == null) {
        return defaultValue;
      }
      return JsonHelper.get(s.data!, path, defaultValue);
    }));

    final bool isChecked = currentValue is bool
        ? currentValue
        : (currentValue is num && currentValue == 1);

    return GestureDetector(
      onTap: !isEnabled ? () => _showForceModifyDialog(context, ref) : null,
      child: AbsorbPointer(
        absorbing: !isEnabled,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.zero,
          child: SwitchListTile(
            title: Text(item.label),
            subtitle: item.description != null ? Text(item.description!) : null,
            value: isChecked,
            onChanged: isEnabled
                ? (bool value) => _onChanged(value, context, ref)
                : null,
          ),
        ),
      ),
    );
  }
}
