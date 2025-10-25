import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/ui/screens/project_view.dart';
import 'package:pipecatflowseditor/ui/screens/readme_page.dart';
import 'package:pipecatflowseditor/ui/widgets/elevated_round_button.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => LaunchScreenState();
}

class LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          spacing: 5,
          children: [
            Spacer(),
            SizedBox(
              width: 300,
              child: ElevatedRoundButton(title: 'Открыть сохраненый проект', onPressed: () {}),
            ),
            SizedBox(
              width: 300,
              child: ElevatedRoundButton(
                title: 'Начать новый проект',
                onPressed: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ProjectView())),
              ),
            ),
            SizedBox(
              width: 300,
              child: ElevatedRoundButton(
                title: 'Информация о приложении',
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ReadmePage())),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
