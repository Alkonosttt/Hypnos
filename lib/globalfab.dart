import 'package:flutter/material.dart';
// for Consumer
import 'package:provider/provider.dart';
// global audio service
import 'globalaudioplayerservice.dart';
// sleep timer
import 'timerpicker.dart';

class SleepTimerFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalAudioService>(
      builder: (context, audioService, child) {
        if (!audioService.isTimerRunning) {
          // hides the FAB when the timer is off
          return SizedBox.shrink();
        }

        final remaining = audioService.remainingTime!;
        final hours = remaining.inHours;
        final minutes = remaining.inMinutes % 60;
        final seconds = remaining.inSeconds % 60;

        String timeText;
        if (hours > 0) {
          timeText = '${hours}h ${minutes}m';
        } else if (minutes > 0) {
          timeText = '${minutes}m ${seconds}s';
        } else {
          timeText = '${seconds}s';
        }

        return FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SleepTimerPicker()),
            );
          },
          label: Text(timeText),
          icon: Icon(Icons.timer),
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF942F67),
        );
      },
    );
  }
}
