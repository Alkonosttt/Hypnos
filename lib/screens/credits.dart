import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markdown_widget/markdown_widget.dart';

class CreditsScreen extends StatefulWidget {
  const CreditsScreen({super.key});

  @override
  State<CreditsScreen> createState() => _CreditsScreenState();
}

class _CreditsScreenState extends State<CreditsScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Row(
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 8,
            child:
                markdownData.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : MarkdownWidget(
                      data: markdownData,
                      config: MarkdownConfig(
                        configs: [
                          H1Config(
                            style: GoogleFonts.caesarDressing(fontSize: 30),
                          ),
                          H2Config(
                            style: GoogleFonts.comfortaa(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF942F67),
                            ),
                          ),
                          PConfig(
                            textStyle: GoogleFonts.comfortaa(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          LinkConfig(
                            style: GoogleFonts.comfortaa(
                              fontSize: 16,
                              color: Color(0xFF942F67),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
    );
  }
}
