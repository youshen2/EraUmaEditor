class JsonHelper {
  static dynamic get(
      Map<String, dynamic> root, String path, dynamic defaultValue) {
    try {
      final keys = path.split('/');
      dynamic current = root;
      for (int i = 0; i < keys.length - 1; i++) {
        if (current is Map<String, dynamic> && current.containsKey(keys[i])) {
          current = current[keys[i]];
        } else {
          return defaultValue;
        }
      }
      final finalKey = keys.last;
      if (current is Map<String, dynamic> && current.containsKey(finalKey)) {
        return current[finalKey];
      }
    } catch (e) {
      // NULL
    }
    return defaultValue;
  }

  static bool keyExists(Map<String, dynamic> root, String path) {
    try {
      final keys = path.split('/');
      dynamic current = root;
      for (int i = 0; i < keys.length - 1; i++) {
        if (current is Map<String, dynamic> && current.containsKey(keys[i])) {
          current = current[keys[i]];
        } else {
          return false;
        }
      }
      final finalKey = keys.last;
      if (current is Map<String, dynamic>) {
        return current.containsKey(finalKey);
      }
    } catch (e) {
      // NULL
    }
    return false;
  }

  static void put(Map<String, dynamic> root, String path, dynamic value) {
    try {
      final keys = path.split('/');
      dynamic current = root;
      for (int i = 0; i < keys.length - 1; i++) {
        final key = keys[i];
        if (current[key] is! Map<String, dynamic>) {
          current[key] = <String, dynamic>{};
        }
        current = current[key];
      }
      current[keys.last] = value;
    } catch (e) {
      // NULL
    }
  }

  static void remove(Map<String, dynamic> root, String path) {
    try {
      final keys = path.split('/');
      if (keys.isEmpty) return;

      dynamic current = root;
      for (int i = 0; i < keys.length - 1; i++) {
        final key = keys[i];
        if (current is Map<String, dynamic> && current.containsKey(key)) {
          current = current[key];
        } else {
          return;
        }
      }

      if (current is Map<String, dynamic>) {
        current.remove(keys.last);
      }
    } catch (e) {
      // NULL
    }
  }
}
