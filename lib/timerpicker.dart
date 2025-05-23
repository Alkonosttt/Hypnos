import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// for global audio service, to be able to access the disposeAll function
import 'globalaudioplayerservice.dart';

class TimerPickerPage extends StatefulWidget {
  const TimerPickerPage({super.key});

  @override
  _TimerPickerPageState createState() => _TimerPickerPageState();
}

class _TimerPickerPageState extends State<TimerPickerPage> {
  Duration _duration = Duration(minutes: 10); // default

  void startTimer() {
    Future.delayed(_duration, () {
      // stops all audio
      GlobalAudioService().disposeAll();
      // goes back after timer runs out
      Navigator.pop(context);
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Set a sleep timer'),
          Slider(
            value: _duration.inMinutes.toDouble(),
            min: 1,
            max: 60,
            divisions: 59,
            label: '${_duration.inMinutes} min',
            onChanged: (value) {
              setState(() {
                _duration = Duration(minutes: value.toInt());
              });
            },
          ),
          ElevatedButton(
            onPressed: startTimer,
            child: Text('Start', style: GoogleFonts.comfortaa(fontSize: 20)),
          ),
        ],
      ),
    );
  }
}
