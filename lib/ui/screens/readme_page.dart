import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/widget/markdown.dart';
import '../../l10n/app_localizations.dart';

class ReadmePage extends StatefulWidget {
  const ReadmePage({super.key});

  @override
  State<ReadmePage> createState() => ReadmePageState();
}

class ReadmePageState extends State<ReadmePage> {
  Future<String> loadAssetAsString(String assetPath) async {
    try {
      String fileContent = await rootBundle.loadString(assetPath);
      return fileContent;
    } catch (e) {
      print('Error loading asset file: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text(loc.userGuide), toolbarHeight: 40, backgroundColor: Colors.black12),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
          future: loadAssetAsString('assets/README.md'),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;
              return MarkdownWidget(data: data);
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
