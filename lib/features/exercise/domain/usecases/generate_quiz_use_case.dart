import 'dart:math';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../learning/domain/entities/word_entity.dart';
import '../../../learning/domain/repositories/vocabulary_repository.dart';
import '../entities/question_entity.dart';
import '../repositories/exercise_repository.dart';

class GenerateQuizUseCase {
  final ExerciseRepository exerciseRepository;
  final VocabularyRepository vocabularyRepository;

  GenerateQuizUseCase({
    required this.exerciseRepository,
    required this.vocabularyRepository,
  });

  Future<Either<Failure, List<QuestionEntity>>> call({
    required String topicId,
    required int quantity,
  }) async {
    try {
      // 1. Lấy danh sách từ vựng theo chủ đề từ repository của Đức
      final words = await vocabularyRepository.getWordsByTopic(topicId);

      if (words.isEmpty) {
        return const Left(ServerFailure('Không có từ vựng nào trong chủ đề này để tạo bài tập.'));
      }

      final random = Random();
      final questions = <QuestionEntity>[];

      // 2. Trộn ngẫu nhiên danh sách từ vựng và chọn ra số lượng câu hỏi (quantity)
      final shuffledWords = List<WordEntity>.from(words)..shuffle(random);
      final selectedWords = shuffledWords.take(quantity).toList();

      // 3. Xây dựng từng câu hỏi
      for (final word in selectedWords) {
        final correctAnswer = word.definition;

        // Tạo danh sách đáp án nhiễu bằng cách lấy ngẫu nhiên các định nghĩa của các từ khác
        final distractors = words
            .where((w) => w.id != word.id) // Loại bỏ từ hiện tại
            .map((w) => w.definition)
            .toList()
          ..shuffle(random);

        // Gộp đáp án đúng và tối đa 3 đáp án nhiễu (tổng 4 options), sau đó trộn đều
        final options = [correctAnswer, ...distractors.take(3)]..shuffle(random);

        questions.add(QuestionEntity(
          id: 'quiz_${word.id}_${DateTime.now().millisecondsSinceEpoch}', // Sinh ID tạm thời
          type: QuestionType.multipleChoice,
          content: 'Chọn nghĩa đúng của từ: ${word.text}',
          correctAnswer: correctAnswer,
          options: options,
          relatedWordId: word.id,
        ));
      }

      return Right(questions);
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}