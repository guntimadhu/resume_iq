import 'package:flutter/material.dart';
import 'app_state.dart';
import 'screens/splash_screen.dart';
import 'services/hive_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  themeModeNotifier.value = HiveService.settings.isDarkMode;
  runApp(const ResumeIQApp());
}

class ResumeIQApp extends StatelessWidget {
  const ResumeIQApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: themeModeNotifier,
      builder: (context, isDark, child) {
        return MaterialApp(
          title: 'ResumeIQ',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
        );
      },
    );
  }
}
