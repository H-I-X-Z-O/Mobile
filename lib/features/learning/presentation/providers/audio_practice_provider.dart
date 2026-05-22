import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/entities/audio_exercise_entity.dart';
import '../../domain/entities/audio_question_entity.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../../data/datasources/learning_remote_data_source.dart';
import '../../data/datasources/learning_local_data_source.dart';
import '../../data/repositories/vocabulary_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Provider quản lý trạng thái của màn hình luyện nghe.
/// Xử lý logic tải bài tập, câu hỏi, phát audio, và chấm điểm.
class AudioPracticeProvider extends ChangeNotifier {
  /// Đối tượng repository để lấy dữ liệu từ xa và cục bộ
  late final VocabularyRepository _repository;
  
  /// Trình phát audio để nghe các đoạn hội thoại/bài nghe
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPracticeProvider() {
    _initRepository();
  }

  /// Khởi tạo repository với các data source cục bộ và từ xa
  void _initRepository() {
    final remoteDs = LearningRemoteDataSourceImpl(
      firestore: FirebaseFirestore.instance,
    );
    final localDs = LearningLocalDataSourceImpl();
    _repository = VocabularyRepositoryImpl(
      remoteDataSource: remoteDs,
      localDataSource: localDs,
    );
  }

  List<AudioExerciseEntity> _exercises = [];
  /// Danh sách các bài luyện nghe hiện có.
  List<AudioExerciseEntity> get exercises => _exercises;

  List<AudioQuestionEntity> _questions = [];
  /// Danh sách câu hỏi cho bài luyện nghe đang được chọn.
  List<AudioQuestionEntity> get questions => _questions;

  bool _isLoading = false;
  /// Trạng thái đang tải dữ liệu (true khi đang tải).
  bool get isLoading => _isLoading;

  // Trạng thái chơi nhạc
  PlayerState _playerState = PlayerState.stopped;
  /// Trạng thái hiện tại của trình phát audio (đang phát, tạm dừng, dừng, v.v.).
  PlayerState get playerState => _playerState;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  /// Tổng thời lượng của audio hiện tại.
  Duration get duration => _duration;
  /// Vị trí phát hiện tại của audio.
  Duration get position => _position;

  // Trạng thái bài làm
  Map<int, int?> _selectedAnswers = {}; // {questionOrder: selectedOptionIndex}
  /// Danh sách các đáp án mà người dùng đã chọn (Key: thứ tự câu hỏi, Value: chỉ số đáp án).
  Map<int, int?> get selectedAnswers => _selectedAnswers;

  bool _isSubmitted = false;
  /// Trạng thái đánh dấu bài kiểm tra đã được nộp hay chưa.
  bool get isSubmitted => _isSubmitted;

  int _score = 0;
  /// Tổng số điểm (số câu trả lời đúng) đạt được.
  int get score => _score;

  /// Khởi tạo các listener để theo dõi trạng thái và tiến độ phát audio.
  void init() {
    // Lắng nghe sự thay đổi trạng thái (phát, dừng, tạm dừng) của trình phát
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
      notifyListeners();
    });

    // Lắng nghe tổng thời lượng của bài audio khi nó được thiết lập
    _audioPlayer.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });

    // Lắng nghe tiến độ phát audio theo thời gian thực để cập nhật thanh tiến trình
    _audioPlayer.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });
  }

  /// Tải danh sách các bài luyện nghe từ cơ sở dữ liệu
  Future<void> loadExercises() async {
    _isLoading = true;
    notifyListeners();

    try {
      _exercises = await _repository.getAudioExercises();
    } catch (e) {
      debugPrint('Error loading audio exercises: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tải danh sách câu hỏi cho một bài luyện nghe cụ thể dựa trên [audioExerciseId].
  /// Xóa các trạng thái bài làm trước đó.
  Future<void> loadQuestions(String audioExerciseId) async {
    _isLoading = true;
    _questions = [];
    _selectedAnswers = {};
    _isSubmitted = false;
    _score = 0;
    notifyListeners();

    try {
      _questions = await _repository.getAudioQuestions(audioExerciseId);
    } catch (e) {
      debugPrint('Error loading audio questions: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Phát audio từ đường dẫn [path]. Nếu là đường dẫn của Firebase Storage, 
  /// sẽ tự động lấy URL download trước khi phát.
  Future<void> playAudio(String path) async {
    try {
      String url = path;
      if (!path.startsWith('http')) {
        // Lấy URL từ Firebase Storage if it's a path
        url = await FirebaseStorage.instance.ref(path).getDownloadURL();
      }
      await _audioPlayer.play(UrlSource(url));
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  /// Tạm dừng audio đang phát
  Future<void> pauseAudio() async => await _audioPlayer.pause();
  
  /// Tiếp tục phát audio
  Future<void> resumeAudio() async => await _audioPlayer.resume();
  
  /// Tua audio đến một [position] cụ thể
  Future<void> seekAudio(Duration position) async => await _audioPlayer.seek(position);

  /// Chọn đáp án [optionIndex] cho câu hỏi có thứ tự [questionOrder]
  void selectAnswer(int questionOrder, int optionIndex) {
    if (_isSubmitted) return;
    _selectedAnswers[questionOrder] = optionIndex;
    notifyListeners();
  }

  /// Nộp bài, chấm điểm dựa trên danh sách câu trả lời đã chọn và dừng phát audio.
  void submitTest() {
    _isSubmitted = true;
    _score = 0;
    // Lặp qua tất cả câu hỏi, tính điểm cho những câu trả lời khớp với đáp án đúng
    for (var q in _questions) {
      if (_selectedAnswers[q.order] == q.correctAnswer) {
        _score++;
      }
    }
    notifyListeners();
    // Tự động dừng trình phát audio sau khi người dùng nộp bài
    _audioPlayer.pause();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
