import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/markdown_widget.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
  // handling the markdown Credits file >>
  String markdownData = '';

  @override
  void initState() {
    super.initState();
    loadMarkdown();
  }

  Future<void> loadMarkdown() async {
    final String data = await rootBundle.loadString('assets/credits.md');
    setState(() {
      markdownData = data;
    });
  }
  // handling the markdown Credits file <<

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(flex: 1, child: SizedBox()),
          Expanded(flex: 8, child: MarkdownWidget(data: markdownData)),
          Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
