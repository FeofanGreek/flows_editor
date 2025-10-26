import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/ui/screens/launch_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'controllers/app_state_controller.dart';
import 'controllers/flow_edit_controller.dart';

void main() {
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
