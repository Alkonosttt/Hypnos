import 'package:flutter/material.dart';
import 'globalaudioplayerservice.dart';
import 'timerpicker.dart';
import 'package:provider/provider.dart';

class SleepTimerFAB extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalAudioService>(
      builder: (context, audioService, child) {
        if (!audioService.isTimerRunning) {
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SleepTimerPicker()),
              );
            },
            child: Icon(Icons.bedtime),
            tooltip: 'Sleep Timer',
          );
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
          backgroundColor: Colors.orange,
        );
      },
    );
  }
}
