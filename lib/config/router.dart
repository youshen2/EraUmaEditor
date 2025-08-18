import 'package:era_uma_editor/presentation/screens/character_info_screen.dart';
import 'package:era_uma_editor/presentation/screens/main_screen.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainScreen(),
      routes: [
        GoRoute(
          path: 'character/:id',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
            return CharacterInfoScreen(characterId: id);
          },
        ),
      ],
    ),
  ],
);
