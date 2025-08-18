import 'package:era_uma_editor/data/models/character_item.dart';
import 'package:era_uma_editor/data/providers/save_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  List<CharacterItem> _getRecruitedCharacters(Map<String, dynamic> data) {
    final List<CharacterItem> characters = [];
    try {
      if (data['callname'] == null || data['cflag'] == null) {
        return [];
      }
      final callnameMap = data['callname'] as Map<String, dynamic>;
      final cflagMap = data['cflag'] as Map<String, dynamic>;

      callnameMap.forEach((key, value) {
        final isRecruited = cflagMap[key]?['66'] == 1;

        if (isRecruited &&
            value is Map<String, dynamic> &&
            value.containsKey('-1')) {
          characters.add(CharacterItem(id: key, name: value['-1'].toString()));
        }
      });
      characters.sort((a, b) => int.parse(a.id).compareTo(int.parse(b.id)));
    } catch (e) {
      // NULL
    }
    return characters;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SaveDataState>(saveDataProvider, (previous, next) {
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    });

    final saveDataState = ref.watch(saveDataProvider);
    final saveDataNotifier = ref.read(saveDataProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('概览'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_open_outlined),
            tooltip: '加载存档',
            onPressed: () => saveDataNotifier.loadFile(),
          ),
          IconButton(
            icon: const Icon(Icons.save_outlined),
            tooltip: '保存存档',
            onPressed: () => saveDataNotifier.saveFile(context),
          ),
        ],
      ),
      body: saveDataState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : saveDataState.data == null
              ? const Center(
                  child: Text('请先加载一个存档文件', style: TextStyle(fontSize: 18)),
                )
              : _buildContentView(
                  context, saveDataState, _getRecruitedCharacters),
    );
  }

  Widget _buildContentView(BuildContext context, SaveDataState state,
      List<CharacterItem> Function(Map<String, dynamic>) getRecruited) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final recruitedCharacters = getRecruited(state.data!);

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '已加载存档文件',
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  state.fileName ?? 'N/A',
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 16),
                Text(
                  '存档版本',
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  '${state.data?['version'] ?? 'N/A'} (${state.data?['code'] ?? 'N/A'})',
                  style: textTheme.bodyLarge
                      ?.copyWith(color: colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '队伍角色 (${recruitedCharacters.length})',
                  style: textTheme.titleMedium
                      ?.copyWith(color: colorScheme.onSurface),
                ),
                const SizedBox(height: 8),
                if (recruitedCharacters.isEmpty)
                  const Text('当前没有已招募的角色。')
                else
                  ...recruitedCharacters.map(
                    (char) => ListTile(
                      title: Text(char.name),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.push('/character/${char.id}'),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
