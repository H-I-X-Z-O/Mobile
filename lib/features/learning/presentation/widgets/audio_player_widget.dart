import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/audio_practice_provider.dart';

/// Widget trình phát âm thanh (Audio Player) cho phép người dùng
/// nghe các đoạn audio, tạm dừng, tiếp tục và tua đến các vị trí khác nhau.
///
/// Widget này sử dụng [AudioPracticeProvider] để quản lý trạng thái phát (đang phát, tạm dừng)
/// cũng như tiến trình (position) và thời lượng (duration) của đoạn audio.
class AudioPlayerWidget extends StatelessWidget {
  /// Khởi tạo widget trình phát âm thanh.
  const AudioPlayerWidget({super.key});

  /// Xây dựng giao diện trình phát âm thanh, bao gồm nút điều khiển phát/tạm dừng
  /// và thanh trượt (slider) hiển thị tiến độ thời gian.
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
                  // Xử lý logic chuyển đổi trạng thái phát/tạm dừng của audio
                  if (provider.playerState == PlayerState.playing) {
                    provider.pauseAudio();
                  } else if (provider.playerState == PlayerState.paused) {
                    provider.resumeAudio();
                  } else {
                    // Bắt đầu phát nếu chưa được khởi tạo (thường được xử lý ở bước khởi tạo của màn hình)
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
                          : 1.0, // Đảm bảo max luôn lớn hơn 0 để tránh lỗi chia cho 0 khi audio chưa tải xong
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

  /// Định dạng thời lượng [Duration] thành chuỗi hiển thị dưới dạng `MM:SS` hoặc `HH:MM:SS`.
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
