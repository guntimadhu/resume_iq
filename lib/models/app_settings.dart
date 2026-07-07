import 'package:hive/hive.dart';

part 'app_settings.g.dart';

class AppSettings extends HiveObject {
  bool isDarkMode;
  bool soundEnabled;
  bool onboardingSeen;

  AppSettings({
    this.isDarkMode = true,
    this.soundEnabled = true,
    this.onboardingSeen = false,
  });
}
