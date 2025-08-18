enum LayoutType { single, double }

enum DataType { int, float, string, boolean, choice, header, info }

enum BooleanRepresentation { asInt, asBoolean }

class EditorItemCondition {
  final String jsonPath;
  final dynamic value;
  final bool isEqual;

  const EditorItemCondition({
    required this.jsonPath,
    required this.value,
    this.isEqual = true,
  });
}

class EditorItem {
  final String label;
  final String? description;
  final String jsonPath;
  final DataType dataType;
  final double? maxValue;
  final String? prefix;
  final String? suffix;
  final LayoutType layoutType;
  final List<EditorChoice>? choices;
  final BooleanRepresentation booleanRepresentation;

  final List<EditorItemCondition>? conditions;

  EditorItem({
    required this.label,
    this.description,
    required this.jsonPath,
    required this.dataType,
    this.maxValue,
    this.prefix,
    this.suffix,
    this.layoutType = LayoutType.single,
    this.choices,
    this.booleanRepresentation = BooleanRepresentation.asInt,
    this.conditions,
  });

  factory EditorItem.header(String title) {
    return EditorItem(label: title, jsonPath: '', dataType: DataType.header);
  }

  factory EditorItem.info(String text) {
    return EditorItem(
      label: text,
      jsonPath: '',
      dataType: DataType.info,
      layoutType: LayoutType.single,
    );
  }
}

class EditorChoice {
  final dynamic value;
  final String displayName;

  EditorChoice(this.value, this.displayName);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is EditorChoice &&
        other.value == value &&
        other.displayName == displayName;
  }

  @override
  int get hashCode => value.hashCode ^ displayName.hashCode;
}
