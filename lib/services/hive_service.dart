import 'package:hive_flutter/hive_flutter.dart';
import '../models/analysis_history.dart';
import '../models/app_settings.dart';

class HiveService {
  HiveService._();

  static const String historyBoxName = 'analysis_history_box';
  static const String settingsBoxName = 'app_settings_box';
  static const String settingsKey = 'settings';

  static late Box<AnalysisHistory> historyBox;
  static late Box<AppSettings> settingsBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(AnalysisHistoryAdapter());
    Hive.registerAdapter(AppSettingsAdapter());

    historyBox = await Hive.openBox<AnalysisHistory>(historyBoxName);
    settingsBox = await Hive.openBox<AppSettings>(settingsBoxName);

    if (settingsBox.get(settingsKey) == null) {
      await settingsBox.put(settingsKey, AppSettings());
    }
  }

  static AppSettings get settings =>
      settingsBox.get(settingsKey) ?? AppSettings();

  static Future<void> saveSettings(AppSettings settings) async {
    await settingsBox.put(settingsKey, settings);
  }

  static List<AnalysisHistory> getAllHistory() {
    final list = historyBox.values.toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  static Future<void> addHistory(AnalysisHistory item) async {
    await historyBox.put(item.id, item);
  }

  static Future<void> deleteHistory(String id) async {
    await historyBox.delete(id);
  }

  static Future<void> clearAllHistory() async {
    await historyBox.clear();
  }

  static double get averageScore {
    final items = historyBox.values.toList();
    if (items.isEmpty) return 0;
    final total = items.fold<int>(0, (sum, item) => sum + item.atsScore);
    return total / items.length;
  }

  static int get bestScore {
    final items = historyBox.values.toList();
    if (items.isEmpty) return 0;
    return items.map((e) => e.atsScore).reduce((a, b) => a > b ? a : b);
  }
}
