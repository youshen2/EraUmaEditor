import 'dart:convert';
import 'package:era_uma_editor/presentation/widgets/animated_shader_background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_io/io.dart';
import 'package:http/http.dart' as http;

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _headerFadeAnimation;
  late Animation<Offset> _headerSlideAnimation;
  late Animation<double> _cardFadeAnimation;
  late Animation<Offset> _cardSlideAnimation;

  final bool _isShaderSupported = !kIsWeb && !Platform.isWindows;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _headerSlideAnimation =
        Tween<Offset>(begin: const Offset(0, -0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _cardFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _cardSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      if (mounted) {
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

  Future<void> _checkForUpdates() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final uri = Uri.parse(
          'https://api.github.com/repos/youshen2/EraUmaEditor/releases/latest');
      final response = await http.get(uri);

      if (mounted) Navigator.of(context).pop();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final latestVersion = (data['tag_name'] as String).replaceAll('v', '');
        final releaseUrl = data['html_url'] as String;

        if (_isNewerVersion(latestVersion, currentVersion)) {
          if (mounted) {
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
                      _launchUrl(releaseUrl);
                      Navigator.of(context).pop();
                    },
                    child: const Text('前往下载'),
                  ),
                ],
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('当前已是最新版本')),
            );
          }
        }
      } else {
        throw Exception('无法获取版本信息');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('检查更新失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_isShaderSupported) const AnimatedShaderBackground(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              children: [
                const SizedBox(height: 60),
                SlideTransition(
                  position: _headerSlideAnimation,
                  child: FadeTransition(
                    opacity: _headerFadeAnimation,
                    child: Column(
                      children: [
                        Image.asset('assets/images/erauma.png',
                            width: 96, height: 96),
                        const SizedBox(height: 16),
                        Text(
                          'EraUma 存档编辑器',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Version 1.1.0 (Flutter)',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                SlideTransition(
                  position: _cardSlideAnimation,
                  child: FadeTransition(
                    opacity: _cardFadeAnimation,
                    child: Card(
                      elevation: 0,
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.6),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('开发者：爅峫'),
                            onTap: () => _launchUrl(
                                'https://space.bilibili.com/394675616'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.code),
                            title: const Text('获取源代码'),
                            onTap: () => _launchUrl(
                                'https://github.com/youshen2/EraUmaEditor'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.system_update_alt),
                            title: const Text('检查更新'),
                            onTap: _checkForUpdates,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
