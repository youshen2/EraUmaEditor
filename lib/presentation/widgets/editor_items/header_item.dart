import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:flutter/material.dart';

class HeaderItem extends StatelessWidget {
  final EditorItem item;

  const HeaderItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, top: 16.0, bottom: 8.0),
      child: Text(
        item.label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
