import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/audio_question_entity.dart';

class AudioQuestionModel extends AudioQuestionEntity {
  const AudioQuestionModel({
    required super.id,
    required super.audioExerciseId,
    required super.audioQuestionId,
    required super.question,
    required super.options,
    required super.correctAnswer,
    super.explanation,
    required super.order,
    required super.questionType,
  });

  factory AudioQuestionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AudioQuestionModel(
      id: doc.id,
      audioExerciseId: data['audioExerciseId'] as String? ?? '',
      audioQuestionId: data['audioQuestionId'] as String? ?? '',
      question: data['question'] as String? ?? '',
      options: (data['options'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      correctAnswer: data['correctAnswer'] as int? ?? 0,
      explanation: data['explanation'] as String? ?? data['explaination'] as String?,
      order: data['order'] as int? ?? 0,
      questionType: data['questionType'] as String? ?? 'multiple_choice',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'audioExerciseId': audioExerciseId,
      'audioQuestionId': audioQuestionId,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'explanation': explanation,
      'order': order,
      'questionType': questionType,
    };
  }
}
