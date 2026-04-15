import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/audio_exercise_entity.dart';

class AudioExerciseModel extends AudioExerciseEntity {
  const AudioExerciseModel({
    required super.id,
    required super.audioExerciseId,
    required super.title,
    super.description,
    required super.audioUrl,
    super.transcript,
    required super.totalQuestions,
    required super.durationMinutes,
    required super.level,
    super.order,
  });

  factory AudioExerciseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AudioExerciseModel(
      id: doc.id,
      audioExerciseId: data['audioExerciseId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String?,
      audioUrl: data['audioUrl'] as String? ?? '',
      transcript: data['transcript'] as String?,
      totalQuestions: data['totalQuestion'] as int? ?? 0,
      durationMinutes: data['durationMinutes'] as int? ?? 0,
      level: data['level'] as String? ?? '',
      order: data['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audioExerciseId': audioExerciseId,
      'title': title,
      'description': description,
      'audioUrl': audioUrl,
      'transcript': transcript,
      'totalQuestion': totalQuestions,
      'durationMinutes': durationMinutes,
      'level': level,
      'order': order,
    };
  }
}
