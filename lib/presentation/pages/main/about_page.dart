import 'package:era_uma_editor/main.dart';
import 'package:era_uma_editor/presentation/widgets/animated_shader_background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:universal_io/io.dart';

class AboutPage extends ConsumerStatefulWidget {
  const AboutPage({super.key});

  @override
  ConsumerState<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends ConsumerState<AboutPage>
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

  Future<void> _checkForUpdates() async {
    await ref.read(updateProvider).checkForUpdates(context,
        showLoadingDialog: true, showNoUpdateSnackbar: true);
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
                          'Version 1.2.0 (Flutter)',
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
