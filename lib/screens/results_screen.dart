import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../models/analysis_history.dart';
import '../theme/app_colors.dart';
import '../widgets/app_toast.dart';
import '../widgets/keyword_chip.dart';
import '../widgets/score_gauge.dart';

class ResultsScreen extends StatefulWidget {
  final AnalysisHistory history;
  final bool justSaved;

  const ResultsScreen({super.key, required this.history, this.justSaved = false});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.justSaved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          AppToast.show(
            context,
            '✅ Analysis saved!',
            color: AppColors.success,
          );
        }
      });
    }
  }

  void _share() {
    final h = widget.history;
    final buffer = StringBuffer()
      ..writeln('ResumeIQ Analysis Report 📄✨')
      ..writeln('Job Title: ${h.jobTitle}')
      ..writeln('ATS Score: ${h.atsScore}/100')
      ..writeln()
      ..writeln('✅ Matching Keywords: ${h.matchingKeywords.join(', ')}')
      ..writeln('❌ Missing Keywords: ${h.missingKeywords.join(', ')}')
      ..writeln()
      ..writeln('💡 Suggestions:');
    for (var i = 0; i < h.suggestions.length; i++) {
      buffer.writeln('${i + 1}. ${h.suggestions[i]}');
    }
    buffer.writeln();
    buffer.writeln('📊 Section Breakdown:');
    h.sectionAnalysis.forEach((key, value) {
      buffer.writeln('- $key: $value');
    });

    Share.share(buffer.toString());
  }

  static const Map<String, String> _sectionEmoji = {
    'contact_info': '📇',
    'summary': '📝',
    'experience': '💼',
    'skills': '🛠️',
    'education': '🎓',
    'formatting': '🗂️',
  };

  static const Map<String, String> _sectionLabel = {
    'contact_info': 'Contact Info',
    'summary': 'Summary',
    'experience': 'Experience',
    'skills': 'Skills',
    'education': 'Education',
    'formatting': 'Formatting',
  };

  @override
  Widget build(BuildContext context) {
    final h = widget.history;
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Results', style: TextStyle(color: context.textPrimary)),
        actions: [
          IconButton(
            icon: Icon(Icons.share, color: context.textPrimary),
            onPressed: _share,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ScoreGauge(score: h.atsScore),
            const SizedBox(height: 8),
            Text(
              '🎯 ATS Match Score',
              style: TextStyle(
                color: context.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            _SectionCard(
              title: '✅ Matching Keywords',
              accentColor: AppColors.success,
              child: h.matchingKeywords.isEmpty
                  ? Text(
                      'No matching keywords found',
                      style: TextStyle(color: context.textSecondary),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var i = 0; i < h.matchingKeywords.length; i++)
                          KeywordChip(
                            label: h.matchingKeywords[i],
                            color: AppColors.success,
                            delayMs: i * 60,
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '❌ Missing Keywords',
              accentColor: AppColors.warning,
              child: h.missingKeywords.isEmpty
                  ? Text(
                      'Great! No missing keywords',
                      style: TextStyle(color: context.textSecondary),
                    )
                  : Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (var i = 0; i < h.missingKeywords.length; i++)
                          KeywordChip(
                            label: h.missingKeywords[i],
                            color: AppColors.warning,
                            delayMs: i * 60,
                          ),
                      ],
                    ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '💡 Suggestions',
              accentColor: AppColors.purpleBright,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < h.suggestions.length; i++)
                    _FadeInSuggestion(
                      index: i,
                      text: h.suggestions[i],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: '📊 Section Breakdown',
              accentColor: AppColors.purpleLight,
              child: Column(
                children: h.sectionAnalysis.entries.map((entry) {
                  final emoji = _sectionEmoji[entry.key] ?? '📌';
                  final label = _sectionLabel[entry.key] ?? entry.key;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label,
                                style: TextStyle(
                                  color: context.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                entry.value,
                                style: TextStyle(
                                  color: context.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Color accentColor;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.accentColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: accentColor, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: context.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FadeInSuggestion extends StatefulWidget {
  final int index;
  final String text;

  const _FadeInSuggestion({required this.index, required this.text});

  @override
  State<_FadeInSuggestion> createState() => _FadeInSuggestionState();
}

class _FadeInSuggestionState extends State<_FadeInSuggestion>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    Future.delayed(Duration(milliseconds: widget.index * 150), () {
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
    return FadeTransition(
      opacity: _controller,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.index + 1}.',
              style: TextStyle(
                color: AppColors.purpleLight,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                widget.text,
                style: TextStyle(color: context.textPrimary, fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
