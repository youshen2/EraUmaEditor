import 'package:dynamic_color/dynamic_color.dart';
import 'package:era_uma_editor/config/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final updateProvider = Provider((ref) => UpdateService());

class UpdateService {
  Future<void> _launchUrl(String url, BuildContext context) async {
    if (!await launchUrl(Uri.parse(url))) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('无法打开链接: $url')),
        );
      }
    }
  }

  bool _isNewerVersion(String newVersion, String currentVersion) {
    final newParts = newVersion.split('.').map(int.parse).toList();
    final currentParts = currentVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < newParts.length; i++) {
      if (i >= currentParts.length) {
        return true;
      }
      if (newParts[i] > currentParts[i]) {
        return true;
      }
      if (newParts[i] < currentParts[i]) {
        return false;
      }
    }
    return false;
  }

  Future<void> checkForUpdates(BuildContext context,
      {bool showLoadingDialog = true,
      bool showNoUpdateSnackbar = false}) async {
    if (showLoadingDialog) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const PopScope(
          canPop: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final uri = Uri.parse(
          'https://api.github.com/repos/youshen2/EraUmaEditor/releases/latest');
      final response = await http.get(uri);

      if (showLoadingDialog && context.mounted) Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestVersion = (data['tag_name'] as String).replaceAll('v', '');
        final releaseUrl = data['html_url'] as String;

        if (_isNewerVersion(latestVersion, currentVersion)) {
          if (context.mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('发现新版本'),
                content: Text(
                    '检测到新版本 $latestVersion (当前版本 $currentVersion)。\n是否前往下载页面？'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('关我屁事'),
                  ),
                  TextButton(
                    onPressed: () {
                      _launchUrl(releaseUrl, context);
                      Navigator.of(context).pop();
                    },
                    child: const Text('前往下载'),
                  ),
                ],
              ),
            );
          }
        } else {
          if (showNoUpdateSnackbar && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('当前已是最新版本')),
            );
          }
        }
      } else {
        if (showLoadingDialog) {
          throw Exception('无法获取版本信息');
        }
      }
    } catch (e) {
      if (showLoadingDialog && context.mounted) {
        try {
          Navigator.of(context).pop();
        } catch (_) {}
      }
      if (showLoadingDialog && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('检查更新失败: $e')),
        );
      }
    }
  }
}

void main() {
  runApp(const ProviderScope(child: EraUmaEditorApp()));
}

class EraUmaEditorApp extends StatelessWidget {
  const EraUmaEditorApp({super.key});

  static final _defaultLightColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blueAccent,
  );
  static final _defaultDarkColorScheme = ColorScheme.fromSeed(
    seedColor: Colors.blueAccent,
    brightness: Brightness.dark,
  );

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp.router(
          title: 'EraUma 存档编辑器',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
          theme: ThemeData(
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
          routerConfig: router,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
