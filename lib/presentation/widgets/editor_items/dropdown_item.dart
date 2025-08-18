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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = item.jsonPath.replaceAll('{id}', characterId.toString());
    final notifier = ref.read(saveDataProvider.notifier);

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<EditorChoice>(
          value: selectedChoice,
          decoration: InputDecoration(
            labelText: item.label,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            hintText: !isEnabled
                ? 'N/A'
                // Show a hint if the value is invalid
                : !isValueInChoices
                    ? '无效值: $currentValue'
                    : null,
          ),
          items: item.choices?.map((EditorChoice choice) {
            return DropdownMenuItem<EditorChoice>(
              value: choice,
              child: Text(choice.displayName),
            );
          }).toList(),
          onChanged: isEnabled && isValueInChoices
              ? (EditorChoice? newValue) {
                  if (newValue != null) {
                    notifier.updateValue(path, newValue.value);
                  }
                }
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
    );
  }
}
