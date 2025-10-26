import 'package:flutter/material.dart';
import 'package:pipecatflowseditor/ui/screens/project_view.dart';
import 'package:pipecatflowseditor/ui/screens/readme_page.dart';
import 'package:pipecatflowseditor/ui/widgets/elevated_round_button.dart';

import '../../l10n/app_localizations.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => LaunchScreenState();
}

class LaunchScreenState extends State<LaunchScreen> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          spacing: 5,
          children: [
            Spacer(),
            SizedBox(
              width: 300,
              child: ElevatedRoundButton(title: loc.openSavedProject, onPressed: () {}),
            ),
            SizedBox(
              width: 300,
              child: ElevatedRoundButton(
                title: loc.startNewProject,
                onPressed: () =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ProjectView())),
              ),
            ),
            SizedBox(
              width: 300,
              child: ElevatedRoundButton(
                title: loc.informationAboutApp,
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
