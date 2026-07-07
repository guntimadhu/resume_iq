import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiAnalysisResult {
  final int atsScore;
  final String jobTitleGuess;
  final List<String> matchingKeywords;
  final List<String> missingKeywords;
  final List<String> suggestions;
  final Map<String, String> sectionAnalysis;

  GeminiAnalysisResult({
    required this.atsScore,
    required this.jobTitleGuess,
    required this.matchingKeywords,
    required this.missingKeywords,
    required this.suggestions,
    required this.sectionAnalysis,
  });

  factory GeminiAnalysisResult.fromJson(Map<String, dynamic> json) {
    final sectionMap = (json['section_analysis'] as Map?) ?? {};
    return GeminiAnalysisResult(
      atsScore: (json['ats_score'] as num?)?.toInt() ?? 0,
      jobTitleGuess: json['job_title_guess']?.toString() ?? 'Unknown Role',
      matchingKeywords: ((json['matching_keywords'] as List?) ?? [])
          .map((e) => e.toString())
          .toList(),
      missingKeywords: ((json['missing_keywords'] as List?) ?? [])
          .map((e) => e.toString())
          .toList(),
      suggestions: ((json['suggestions'] as List?) ?? [])
          .map((e) => e.toString())
          .toList(),
      sectionAnalysis: sectionMap.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      ),
    );
  }
}

class GeminiParseException implements Exception {
  final String message;
  GeminiParseException(this.message);
}

class GeminiService {
  GeminiService._();

  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  static const String _model = 'gemini-1.5-flash';
  static const String _baseUrl =
      'https://generativelanguage.googleapis.com/v1beta/models';

  static String _buildPrompt(String resumeText, String jdText) {
    return '''
Analyze this resume against the job description and respond ONLY with valid JSON, no extra text, no markdown:
{
  "ats_score": <number 0-100>,
  "job_title_guess": "<short job title from JD>",
  "matching_keywords": ["keyword1", "keyword2"],
  "missing_keywords": ["keyword1", "keyword2"],
  "suggestions": ["suggestion 1", "suggestion 2", "suggestion 3"],
  "section_analysis": {
    "contact_info": "<short feedback>",
    "summary": "<short feedback>",
    "experience": "<short feedback>",
    "skills": "<short feedback>",
    "education": "<short feedback>",
    "formatting": "<short feedback>"
  }
}

Resume:
$resumeText

Job Description:
$jdText
''';
  }

  static Future<GeminiAnalysisResult> analyze({
    required String resumeText,
    required String jdText,
  }) async {
    final uri = Uri.parse('$_baseUrl/$_model:generateContent?key=$_apiKey');
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': _buildPrompt(resumeText, jdText)},
          ],
        },
      ],
    });

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw GeminiParseException('Request failed: ${response.statusCode}');
    }

    String text;
    try {
      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = decoded['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        throw GeminiParseException('No candidates returned');
      }
      final content = candidates.first['content'] as Map<String, dynamic>;
      final parts = content['parts'] as List;
      text = parts.first['text'] as String;
    } catch (e) {
      throw GeminiParseException('Could not parse Gemini response');
    }

    final cleaned = _stripMarkdown(text);

    try {
      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return GeminiAnalysisResult.fromJson(json);
    } catch (e) {
      throw GeminiParseException('Could not parse JSON from AI response');
    }
  }

  static String _stripMarkdown(String text) {
    var cleaned = text.trim();
    if (cleaned.startsWith('```')) {
      cleaned = cleaned.replaceFirst(RegExp(r'^```[a-zA-Z]*\n?'), '');
      if (cleaned.endsWith('```')) {
        cleaned = cleaned.substring(0, cleaned.length - 3);
      }
    }
    return cleaned.trim();
  }
}
