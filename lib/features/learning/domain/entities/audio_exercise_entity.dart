import 'package:equatable/equatable.dart';

class AudioExerciseEntity extends Equatable {
  final String id;
  final String audioExerciseId; // ID từ Firestore field
  final String title;
  final String? description;
  final String audioUrl;
  final String? transcript;
  final int totalQuestions;
  final int durationMinutes;
  final String level;
  final int order;

  const AudioExerciseEntity({
    required this.id,
    required this.audioExerciseId,
    required this.title,
    this.description,
    required this.audioUrl,
    this.transcript,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.level,
    this.order = 0,
  });

  @override
  List<Object?> get props => [
        id,
        audioExerciseId,
        title,
        description,
        audioUrl,
        transcript,
        totalQuestions,
        durationMinutes,
        level,
        order,
      ];
}
