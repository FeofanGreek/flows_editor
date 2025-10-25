import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/ui/screens/launch_screen.dart';
import 'package:provider/provider.dart';

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
        home: LaunchScreen(),
      ),
    );
  }
}
