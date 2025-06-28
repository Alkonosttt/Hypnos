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
        final remaining = audioService.remainingTime;

        // Hide FAB if timer is off or completed
        if (remaining == null) {
          return SizedBox.shrink();
        }

        final isPaused = audioService.isTimerPaused;

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
            if (isPaused) {
              audioService.resumeTimer();
            } else {
              audioService.pauseTimer();
            }
          },
          label: Text(
            isPaused ? 'Paused: $timeText' : timeText,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
          backgroundColor: isPaused ? Colors.grey[200] : Colors.white,
          foregroundColor: const Color(0xFF942F67),
        );
      },
    );
  }
}
