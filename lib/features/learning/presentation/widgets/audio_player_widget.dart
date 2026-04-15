import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/audio_practice_provider.dart';

class AudioPlayerWidget extends StatelessWidget {
  const AudioPlayerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.appTheme;
    final provider = context.watch<AudioPracticeProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: t.cardBackground,
        borderRadius: BorderRadius.circular(AppDimensions.r16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: t.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (provider.playerState == PlayerState.playing) {
                    provider.pauseAudio();
                  } else if (provider.playerState == PlayerState.paused) {
                    provider.resumeAudio();
                  } else {
                    // Start playing if not started (handled in screen init usually)
                  }
                },
                icon: Icon(
                  provider.playerState == PlayerState.playing
                      ? Icons.pause_circle_filled_rounded
                      : Icons.play_circle_filled_rounded,
                  color: AppColors.primary,
                  size: 48,
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Slider(
                      value: provider.position.inSeconds.toDouble(),
                      max: provider.duration.inSeconds.toDouble() > 0 
                          ? provider.duration.inSeconds.toDouble() 
                          : 1.0,
                      activeColor: AppColors.primary,
                      inactiveColor: AppColors.primary.withAlpha(50),
                      onChanged: (val) {
                        provider.seekAudio(Duration(seconds: val.toInt()));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(provider.position),
                            style: TextStyle(fontSize: 12, color: t.textSecondary),
                          ),
                          Text(
                            _formatDuration(provider.duration),
                            style: TextStyle(fontSize: 12, color: t.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
