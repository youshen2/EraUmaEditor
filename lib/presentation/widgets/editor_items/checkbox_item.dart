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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = item.jsonPath.replaceAll('{id}', characterId.toString());
    final notifier = ref.read(saveDataProvider.notifier);

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

    return Card(
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
            ? (bool value) {
                dynamic valueToPut;
                if (item.booleanRepresentation == BooleanRepresentation.asInt) {
                  valueToPut = value ? 1 : 0;
                } else {
                  valueToPut = value;
                }
                notifier.updateValue(path, valueToPut);
              }
            : null,
      ),
    );
  }
}
