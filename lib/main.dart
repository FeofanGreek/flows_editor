import 'package:flutter/material.dart';
import '../ui/screens/launch_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:window_manager/window_manager.dart';
import 'l10n/app_localizations.dart';
import 'controllers/app_state_controller.dart';
import 'controllers/flow_edit_controller.dart';

void main() async {
  // Убедитесь, что биндинг Flutter инициализирован
  WidgetsFlutterBinding.ensureInitialized();

  // Добавьте это, чтобы убедиться, что window_manager готов
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    // Здесь можно настроить другие параметры окна
    size: Size(800, 600),
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal, // Убедитесь, что заголовок отображается
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    // Установите желаемый заголовок окна
    await windowManager.setTitle('Мой новый заголовок окна macOS');
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //перечисление провайдеров
        ChangeNotifierProvider(create: (_) => AppStateController()),
        ChangeNotifierProvider(create: (_) => FLowEditController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PipeCat framework flows editor',
        supportedLocales: const [Locale('en'), Locale('ru')],
        localizationsDelegates: const [
          AppLocalizations.delegate, // Наш делегат
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        locale: Locale('ru'),
        home: LaunchScreen(),
      ),
    );
  }
}
