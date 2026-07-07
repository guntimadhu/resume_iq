import 'dart:ui';
import 'package:flutter/material.dart';
import '../app_state.dart';
import '../services/hive_service.dart';
import '../theme/app_colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _isDarkMode;
  late bool _soundEnabled;

  @override
  void initState() {
    super.initState();
    final settings = HiveService.settings;
    _isDarkMode = settings.isDarkMode;
    _soundEnabled = settings.soundEnabled;
  }

  Future<void> _toggleDarkMode(bool value) async {
    setState(() => _isDarkMode = value);
    final settings = HiveService.settings;
    settings.isDarkMode = value;
    await HiveService.saveSettings(settings);
    themeModeNotifier.value = value;
  }

  Future<void> _toggleSound(bool value) async {
    setState(() => _soundEnabled = value);
    final settings = HiveService.settings;
    settings.soundEnabled = value;
    await HiveService.saveSettings(settings);
  }

  Future<void> _clearHistory() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text(
            '⚠️ Delete ALL analysis history?',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: const Text(
            'This action cannot be undone.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Delete All',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed == true) {
      await HiveService.clearAllHistory();
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = HiveService.getAllHistory().length;
    final avg = HiveService.averageScore.round();
    final best = HiveService.bestScore;

    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Settings', style: TextStyle(color: context.textPrimary)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Text(
              'ResumeIQ',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.silver,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'v1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(color: context.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  _StatItem(label: 'Total', value: '$total'),
                  _StatItem(label: 'Average', value: '$avg'),
                  _StatItem(label: 'Best', value: '$best'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _SettingsCard(
              children: [
                _SettingsSwitchRow(
                  emoji: '🌙',
                  title: 'Dark Mode',
                  value: _isDarkMode,
                  onChanged: _toggleDarkMode,
                ),
                const Divider(color: AppColors.textSecondary, height: 1),
                _SettingsSwitchRow(
                  emoji: '🔔',
                  title: 'Sound on complete',
                  value: _soundEnabled,
                  onChanged: _toggleSound,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsCard(
              children: [
                ListTile(
                  leading: const Text('🗑️', style: TextStyle(fontSize: 20)),
                  title: const Text(
                    'Clear All History',
                    style: TextStyle(color: AppColors.danger),
                  ),
                  onTap: _clearHistory,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'ResumeIQ v1.0.0 — AI Resume Analyzer',
                textAlign: TextAlign.center,
                style: TextStyle(color: context.textSecondary, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.purpleLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: context.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  final String emoji;
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchRow({
    required this.emoji,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(emoji, style: const TextStyle(fontSize: 20)),
      title: Text(title, style: TextStyle(color: context.textPrimary)),
      trailing: Switch(
        value: value,
        activeThumbColor: AppColors.purpleBright,
        onChanged: onChanged,
      ),
    );
  }
}
