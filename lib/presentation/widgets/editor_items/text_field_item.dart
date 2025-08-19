import 'package:era_uma_editor/data/models/editor_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextFieldItem extends ConsumerStatefulWidget {
  final EditorItem item;
  final int characterId;
  final bool isEnabled;

  const TextFieldItem({
    super.key,
    required this.item,
    required this.characterId,
    required this.isEnabled,
  });

  @override
  ConsumerState<TextFieldItem> createState() => _TextFieldItemState();
}

class _TextFieldItemState extends ConsumerState<TextFieldItem> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late final String _path;
  late String _initialValueFromProvider;

  @override
  void initState() {
    super.initState();
    _path =
        widget.item.jsonPath.replaceAll('{id}', widget.characterId.toString());

    final initialValue =
        ref.read(saveDataProvider.notifier).getValue(_path, '');
    _initialValueFromProvider = initialValue.toString();
    _controller.text = _initialValueFromProvider;

    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _saveChanges();
    }
  }

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

  Future<void> _saveChanges() async {
    if (!widget.isEnabled) return;

    final notifier = ref.read(saveDataProvider.notifier);
    final currentText = _controller.text;

    if (currentText == _initialValueFromProvider) {
      return;
    }

    bool shouldUpdate = true;
    if (widget.item.warningMessage != null && context.mounted) {
      shouldUpdate =
          await _showWarningDialog(context, widget.item.warningMessage!);
    }

    if (!shouldUpdate) {
      _controller.text = _initialValueFromProvider; // Revert if cancelled
      return;
    }

    try {
      dynamic valueToPut;
      switch (widget.item.dataType) {
        case DataType.int:
          valueToPut = int.tryParse(currentText) ?? 0;
          break;
        case DataType.float:
          valueToPut = double.tryParse(currentText) ?? 0.0;
          break;
        case DataType.string:
          valueToPut = currentText;
          break;
        default:
          _controller.text = _initialValueFromProvider;
          return;
      }

      notifier.updateValue(_path, valueToPut);
      _initialValueFromProvider = currentText;
    } catch (e) {
      _controller.text = _initialValueFromProvider;
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Re-sync controller if external data changes and field is not focused
    final currentValue = ref.watch(saveDataProvider.select((s) => s.data != null
        ? ref.read(saveDataProvider.notifier).getValue(_path, '')
        : ''));
    final currentValueString = currentValue.toString();
    if (currentValueString != _initialValueFromProvider &&
        !_focusNode.hasFocus) {
      _controller.text = currentValueString;
      _initialValueFromProvider = currentValueString;
    }

    if (!widget.isEnabled && _controller.text.isEmpty) {
      _controller.text = '无效';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.isEnabled,
          decoration: InputDecoration(
            labelText: widget.item.label,
            border: const OutlineInputBorder(),
            prefixText: widget.item.prefix,
            suffixText: widget.item.suffix,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          ),
          keyboardType: (widget.item.dataType == DataType.int ||
                  widget.item.dataType == DataType.float)
              ? TextInputType.numberWithOptions(
                  decimal: widget.item.dataType == DataType.float, signed: true)
              : TextInputType.text,
          inputFormatters: (widget.item.dataType == DataType.int)
              ? [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*'))]
              : (widget.item.dataType == DataType.float
                  ? [FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*'))]
                  : []),
          onFieldSubmitted: (_) => _saveChanges(),
        ),
        if (widget.item.description != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              widget.item.description!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}
