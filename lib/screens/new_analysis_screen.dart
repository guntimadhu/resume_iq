import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/analysis_history.dart';
import '../services/gemini_service.dart';
import '../services/hive_service.dart';
import '../services/sound_service.dart';
import '../theme/app_colors.dart';
import 'results_screen.dart';

class NewAnalysisScreen extends StatefulWidget {
  const NewAnalysisScreen({super.key});

  @override
  State<NewAnalysisScreen> createState() => _NewAnalysisScreenState();
}

class _NewAnalysisScreenState extends State<NewAnalysisScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _resumeTextController = TextEditingController();
  final TextEditingController _jdController = TextEditingController();

  String? _pickedFileName;
  String? _pickedFileText;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _resumeTextController.dispose();
    _jdController.dispose();
    super.dispose();
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null || result.files.single.path == null) return;

    final path = result.files.single.path!;
    final bytes = await File(path).readAsBytes();
    final document = PdfDocument(inputBytes: bytes);
    final text = PdfTextExtractor(document).extractText();
    document.dispose();

    setState(() {
      _pickedFileName = result.files.single.name;
      _pickedFileText = text;
    });
  }

  Future<void> _analyze() async {
    final resumeText = _tabController.index == 0
        ? (_pickedFileText ?? '')
        : _resumeTextController.text.trim();
    final jdText = _jdController.text.trim();

    if (resumeText.isEmpty || jdText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please add both resume and job description'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await GeminiService.analyze(
        resumeText: resumeText,
        jdText: jdText,
      );

      final settings = HiveService.settings;
      if (settings.soundEnabled) {
        SoundService.playBeep();
      }

      final history = AnalysisHistory(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        jobTitle: result.jobTitleGuess,
        date: DateTime.now(),
        atsScore: result.atsScore,
        matchingKeywords: result.matchingKeywords,
        missingKeywords: result.missingKeywords,
        suggestions: result.suggestions,
        sectionAnalysis: result.sectionAnalysis,
        resumeTextSnapshot: resumeText,
        jdTextSnapshot: jdText,
      );
      await HiveService.addHistory(history);

      if (!mounted) return;
      setState(() => _isLoading = false);

      await Navigator.of(context).push(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) =>
              ResultsScreen(history: history, justSaved: true),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final tween = Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeOut));
            return SlideTransition(position: animation.drive(tween), child: child);
          },
        ),
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on GeminiParseException {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ AI could not parse response. Please try again.'),
          backgroundColor: AppColors.danger,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Something went wrong: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'New Analysis',
          style: TextStyle(color: context.textPrimary),
        ),
      ),
      body: _isLoading
          ? const _LoadingView()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: context.cardBg,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        gradient: AppColors.purpleGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: context.textSecondary,
                      tabs: const [
                        Tab(text: '📄 Upload PDF'),
                        Tab(text: '✍️ Paste Text'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 220,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildUploadTab(context),
                        _buildPasteTab(context),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Job Description',
                    style: TextStyle(
                      color: context.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextArea(
                    controller: _jdController,
                    hint: '✍️ Paste the job description here...',
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: AppColors.purpleGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: _analyze,
                          child: const Center(
                            child: Text(
                              '🔍 Analyze with AI',
                              style: TextStyle(
                                color: AppColors.silver,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildUploadTab(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton(
            onPressed: _pickPdf,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.purpleLight,
              side: const BorderSide(color: AppColors.purpleLight),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('📎 Choose PDF File'),
          ),
          const SizedBox(height: 16),
          if (_pickedFileName != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.purpleBright.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _pickedFileName!,
                style: const TextStyle(color: AppColors.purpleLight),
              ),
            )
          else
            Text(
              'No file selected',
              style: TextStyle(color: context.textSecondary),
            ),
        ],
      ),
    );
  }

  Widget _buildPasteTab(BuildContext context) {
    return _buildTextArea(
      controller: _resumeTextController,
      hint: 'Paste your resume text here...',
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        maxLines: null,
        expands: true,
        style: TextStyle(color: context.textPrimary),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(16),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: context.textSecondary),
        ),
      ),
    );
  }
}

class _LoadingView extends StatefulWidget {
  const _LoadingView();

  @override
  State<_LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<_LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 56,
            height: 56,
            child: CircularProgressIndicator(
              color: AppColors.purpleBright,
              strokeWidth: 4,
            ),
          ),
          const SizedBox(height: 24),
          AnimatedBuilder(
            animation: _shimmerController,
            builder: (context, child) {
              final opacity =
                  0.4 + 0.6 * (1 - (_shimmerController.value - 0.5).abs() * 2);
              return Opacity(
                opacity: opacity.clamp(0.4, 1.0),
                child: const Text(
                  'Analyzing your resume... 🤖',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
