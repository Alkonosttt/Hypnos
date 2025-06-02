import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
// for global audio service, to be able to access the disposeAll function
import 'globalaudioplayerservice.dart'; // TimerScreen.dart

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});
  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

final anyAudioPlaying = GlobalAudioService().anyAudioPlaying();

class _TimerScreenState extends State<TimerScreen> {
  Duration selectedDuration = Duration(minutes: 10);

  void setAndStartTimer() {
    final audioService = GlobalAudioService();
    if (anyAudioPlaying) {
      audioService.startTimer(selectedDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioService = GlobalAudioService();
    return Scaffold(
      appBar: AppBar(title: Text('Timer')),
      body: Column(
        children: [
          DropdownButton<Duration>(
            value: selectedDuration,
            items:
                [
                  Duration(minutes: 5),
                  Duration(minutes: 10),
                  Duration(minutes: 30),
                  Duration(hours: 1),
                ].map((duration) {
                  return DropdownMenuItem(
                    value: duration,
                    child: Text('${duration.inMinutes} min'),
                  );
                }).toList(),
            onChanged: (val) => setState(() => selectedDuration = val!),
          ),
          ElevatedButton(
            onPressed: setAndStartTimer,
            child: Text("Start Timer"),
          ),
          if (audioService.isTimerRunning)
            Text(
              "Time remaining: ${audioService.remainingTime?.inMinutes} min",
            ),
        ],
      ),
    );
  }
}
