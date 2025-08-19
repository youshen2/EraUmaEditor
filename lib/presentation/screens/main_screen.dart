import 'package:era_uma_editor/main.dart';
import 'package:era_uma_editor/presentation/screens/mobile/main_screen_mobile.dart';
import 'package:era_uma_editor/presentation/screens/windows/main_screen_windows.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:universal_io/io.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(updateProvider).checkForUpdates(context,
            showLoadingDialog: false, showNoUpdateSnackbar: false);
      }
    });
  }

  bool _isDesktop() {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  @override
  Widget build(BuildContext context) {
    if (_isDesktop()) {
      return const MainScreenWindows();
    } else {
      return const MainScreenMobile();
    }
  }
}
