import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/analysis_history.dart';
import '../services/hive_service.dart';
import '../theme/app_colors.dart';
import '../widgets/app_toast.dart';
import '../widgets/empty_state.dart';
import 'new_analysis_screen.dart';
import 'results_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<AnalysisHistory> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _loadHistory() {
    setState(() {
      _history = HiveService.getAllHistory();
    });
  }

  Future<void> _openNewAnalysis() async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => const NewAnalysisScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOut));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    );
    if (result == true) _loadHistory();
  }

  void _openResults(AnalysisHistory item) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) => ResultsScreen(history: item),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOut));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
      ),
    ).then((_) => _loadHistory());
  }

  Future<void> _editJobTitle(AnalysisHistory item) async {
    final controller = TextEditingController(text: item.jobTitle);
    final newTitle = await showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => BackdropDialog(
        child: AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text(
            '✏️ Edit job title',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: TextField(
            controller: controller,
            autofocus: true,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (newTitle != null && newTitle.isNotEmpty) {
      item.jobTitle = newTitle;
      await item.save();
      _loadHistory();
    }
  }

  Future<void> _deleteWithConfirm(AnalysisHistory item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => BackdropDialog(
        child: AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text(
            '⚠️ Delete this analysis?',
            style: TextStyle(color: AppColors.textPrimary),
          ),
          content: const Text(
            'This action can be undone for a few seconds.',
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
                'Delete',
                style: TextStyle(color: AppColors.danger),
              ),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true) return;

    setState(() => _history.removeWhere((h) => h.id == item.id));
    await HiveService.deleteHistory(item.id);

    bool undone = false;
    if (!mounted) return;
    AppToast.show(
      context,
      'Analysis deleted',
      color: AppColors.danger,
      duration: const Duration(seconds: 7),
      actionLabel: 'Undo',
      onAction: () async {
        undone = true;
        await HiveService.addHistory(item);
        if (mounted) _loadHistory();
      },
    );
    Future.delayed(const Duration(seconds: 7), () {
      if (!undone) _loadHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = _history.length;
    final avgScore = HiveService.averageScore;

    return Scaffold(
      backgroundColor: context.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            if (total > 0) _buildStatsCard(total, avgScore),
            Expanded(
              child: _history.isEmpty
                  ? const EmptyState(
                      emoji: '📄',
                      title: 'No analyses yet',
                      subtitle: 'Tap + to analyze your first resume',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                      itemCount: _history.length,
                      itemBuilder: (context, index) {
                        return _AnimatedHistoryCard(
                          key: ValueKey(_history[index].id),
                          item: _history[index],
                          index: index,
                          onTap: () => _openResults(_history[index]),
                          onEdit: () => _editJobTitle(_history[index]),
                          onDelete: () => _deleteWithConfirm(_history[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: _BounceFab(onTap: _openNewAnalysis),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 16),
      decoration: const BoxDecoration(gradient: AppColors.appBarGradient),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'ResumeIQ 📄',
              style: TextStyle(
                color: AppColors.silver,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.silver),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              ).then((_) => _loadHistory());
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(int total, double avgScore) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: _StatPill(
              label: 'Total Analyses',
              value: '$total',
              icon: '📊',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _StatPill(
              label: 'Average Score',
              value: avgScore.round().toString(),
              icon: '🎯',
            ),
          ),
        ],
      ),
    );
  }
}

class BackdropDialog extends StatelessWidget {
  final Widget child;
  const BackdropDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
      child: child,
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label;
  final String value;
  final String icon;

  const _StatPill({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.purpleLight,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: context.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _AnimatedHistoryCard extends StatefulWidget {
  final AnalysisHistory item;
  final int index;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AnimatedHistoryCard({
    super.key,
    required this.item,
    required this.index,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<_AnimatedHistoryCard> createState() => _AnimatedHistoryCardState();
}

class _AnimatedHistoryCardState extends State<_AnimatedHistoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.index * 100), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final color = AppColors.scoreColor(item.atsScore);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.onTap,
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: context.cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border(
                    left: BorderSide(color: color, width: 4),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '🎯 ${item.jobTitle}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: context.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '📅 ${DateFormat.yMMMd().format(item.date)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: context.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${item.atsScore}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 18),
                          color: AppColors.silver,
                          onPressed: widget.onEdit,
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 18),
                          color: AppColors.danger,
                          onPressed: widget.onDelete,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BounceFab extends StatefulWidget {
  final VoidCallback onTap;
  const _BounceFab({required this.onTap});

  @override
  State<_BounceFab> createState() => _BounceFabState();
}

class _BounceFabState extends State<_BounceFab>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scale = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.85).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.85, end: 1.0).chain(
          CurveTween(curve: Curves.elasticOut),
        ),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,
            child: Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                gradient: AppColors.purpleGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          );
        },
      ),
    );
  }
}
