import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/progress_provider.dart';
import '../providers/reward_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section(context, 'Appearance'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.palette_outlined),
              title: const Text('Theme'),
              subtitle: Text(_themeLabel(settings.themeMode)),
              trailing: DropdownButton<ThemeMode>(
                value: settings.themeMode,
                underline: const SizedBox.shrink(),
                onChanged: (value) {
                  if (value != null) settings.setThemeMode(value);
                },
                items: const [
                  DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                  DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _section(context, 'Sound'),
          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  secondary: const Icon(Icons.volume_up_outlined),
                  title: const Text('Lesson sounds'),
                  subtitle: const Text('Pronunciation, feedback, and rewards'),
                  value: settings.soundEnabled,
                  onChanged: settings.setSoundEnabled,
                ),
                if (settings.soundEnabled)
                  ListTile(
                    leading: const Icon(Icons.volume_down_outlined),
                    title: const Text('Sound volume'),
                    subtitle: Slider(
                      value: settings.volume,
                      onChanged: settings.setVolume,
                    ),
                  ),
                SwitchListTile.adaptive(
                  secondary: const Icon(Icons.music_note_outlined),
                  title: const Text('Background music'),
                  value: settings.musicEnabled,
                  onChanged: settings.setMusicEnabled,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _section(context, 'Learning'),
          Card(
            child: SwitchListTile.adaptive(
              secondary: const Icon(Icons.notifications_none_rounded),
              title: const Text('Learning reminders'),
              subtitle: const Text('Allow reminders when notifications are available'),
              value: settings.notificationsEnabled,
              onChanged: settings.setNotificationsEnabled,
            ),
          ),
          const SizedBox(height: 20),
          _section(context, 'Progress'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.restart_alt_rounded, color: Colors.red),
              title: const Text("Reset this device's progress"),
              subtitle: const Text('Lessons, XP, coins, and locally saved rewards'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => _confirmReset(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(BuildContext context, String title) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 8),
        child: Text(title, style: Theme.of(context).textTheme.titleMedium),
      );

  String _themeLabel(ThemeMode mode) => switch (mode) {
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
        ThemeMode.system => 'Use device setting',
      };

  Future<void> _confirmReset(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset progress?'),
        content: const Text('This cannot be undone on this device.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await context.read<ProgressProvider>().resetLocalProgress();
    await context.read<RewardProvider>().resetLocalRewards();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Progress has been reset on this device.')),
      );
    }
  }
}
