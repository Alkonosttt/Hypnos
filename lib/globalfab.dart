import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// for Consumer
import 'package:provider/provider.dart';
// global audio service
import 'globalaudioplayerservice.dart';

class SleepTimerFAB extends StatelessWidget {
  const SleepTimerFAB({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalAudioService>(
      builder: (context, audioService, child) {
        final remaining = audioService.remainingTime;

        // hides FAB if timer is off or completed
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
            isPaused ? 'paused: $timeText' : timeText,
            style: GoogleFonts.comfortaa(),
          ),
          icon: Icon(isPaused ? Icons.play_arrow : Icons.pause),
          backgroundColor: isPaused ? Colors.grey[200] : Colors.white,
          foregroundColor: const Color(0xFF942F67),
        );
      },
    );
  }
}
