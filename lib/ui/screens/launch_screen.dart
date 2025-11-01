import 'package:flutter/material.dart';
import '../../ui/screens/project_view.dart';
import '../../ui/screens/readme_page.dart';
import '../../ui/widgets/elevated_round_button.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_state_controller.dart';
import '../../controllers/flow_edit_controller.dart';
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
    final controller = context.watch<FLowEditController>();
    final appState = context.watch<AppStateController>();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          spacing: 5,
          children: [
            Spacer(),
            SizedBox(
              width: 300,
              child: ElevatedRoundButton(
                title: loc.openSavedProject,
                onPressed: () async {
                  final pr = await appState.loadProject(context);
                  if (pr != null) {
                    controller.flowModel = pr;
                    controller.update();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => ProjectView()));
                  }
                },
              ),
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
