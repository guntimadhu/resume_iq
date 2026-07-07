import 'package:hive/hive.dart';

part 'analysis_history.g.dart';

class AnalysisHistory extends HiveObject {
  String id;
  String jobTitle;
  DateTime date;
  int atsScore;
  List<String> matchingKeywords;
  List<String> missingKeywords;
  List<String> suggestions;
  Map<String, String> sectionAnalysis;
  String resumeTextSnapshot;
  String jdTextSnapshot;

  AnalysisHistory({
    required this.id,
    required this.jobTitle,
    required this.date,
    required this.atsScore,
    required this.matchingKeywords,
    required this.missingKeywords,
    required this.suggestions,
    required this.sectionAnalysis,
    required this.resumeTextSnapshot,
    required this.jdTextSnapshot,
  });
}
