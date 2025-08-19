import 'dart:convert';
import 'package:era_uma_editor/utils/json_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart' as universal_io;
import 'package:path/path.dart' as p;

final saveDataProvider = StateNotifierProvider<SaveDataNotifier, SaveDataState>(
  (ref) {
    return SaveDataNotifier();
  },
);

class SaveDataState {
  final Map<String, dynamic>? data;
  final String? fileName;
  final bool isLoading;
  final String? error;

  SaveDataState({this.data, this.fileName, this.isLoading = false, this.error});

  SaveDataState copyWith({
    Map<String, dynamic>? data,
    String? fileName,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return SaveDataState(
      data: data ?? this.data,
      fileName: fileName ?? this.fileName,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class SaveDataNotifier extends StateNotifier<SaveDataState> {
  SaveDataNotifier() : super(SaveDataState());

  Future<void> loadFile() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.any);

      if (result != null && result.files.single.path != null) {
        final file = universal_io.File(result.files.single.path!);
        final bytes = await file.readAsBytes();
        String content;

        try {
          final decompressed = universal_io.gzip.decode(bytes);
          content = utf8.decode(decompressed);
        } catch (e) {
          content = utf8.decode(bytes);
        }

        final dynamic decoded = jsonDecode(content);
        if (decoded is! Map<String, dynamic>) {
          throw const FormatException('存档文件不是有效的 JSON 对象。');
        }
        if (!decoded.containsKey('version') ||
            !decoded.containsKey('callname')) {
          throw const FormatException('文件内容不符合 EraUma 存档格式。');
        }
        final jsonData = decoded;

        state = state.copyWith(
          data: jsonData,
          fileName: result.files.single.name,
          isLoading: false,
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '加载失败：无效的存档文件格式。');
    }
  }

  Future<void> saveFile(BuildContext context) async {
    if (state.data == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('没有可保存的数据')));
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      const encoder = JsonEncoder.withIndent('  ');
      final content = encoder.convert(state.data!);
      String? outputFile;
      String? outputFileName;

      if (universal_io.Platform.isAndroid || universal_io.Platform.isIOS) {
        final bytes = utf8.encode(content);
        outputFile = await FilePicker.platform.saveFile(
          dialogTitle: '请选择保存位置',
          fileName: state.fileName ?? 'save.sav',
          bytes: bytes,
        );
        if (outputFile != null) {
          outputFileName = state.fileName ?? 'save.sav';
        }
      } else {
        outputFile = await FilePicker.platform.saveFile(
          dialogTitle: '请选择保存位置',
          fileName: state.fileName ?? 'save.sav',
        );

        if (outputFile != null) {
          final file = universal_io.File(outputFile);
          await file.writeAsString(content);
          outputFileName = p.basename(outputFile);
        }
      }

      if (outputFile != null) {
        state = state.copyWith(isLoading: false, fileName: outputFileName);

        if (context.mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('存档保存成功')));
        }
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: '保存文件失败: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('保存文件失败: $e')));
      }
    }
  }

  void updateValue(String path, dynamic value) {
    if (state.data == null) return;

    final newData = Map<String, dynamic>.from(state.data!);
    JsonHelper.put(newData, path, value);

    state = state.copyWith(data: newData);
  }

  void removeValue(String path) {
    if (state.data == null) return;

    final newData = Map<String, dynamic>.from(state.data!);
    JsonHelper.remove(newData, path);
    state = state.copyWith(data: newData);
  }

  dynamic getValue(String path, dynamic defaultValue) {
    if (state.data == null) return defaultValue;
    return JsonHelper.get(state.data!, path, defaultValue);
  }
}
