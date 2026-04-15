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

class AudioPracticeProvider extends ChangeNotifier {
  late final VocabularyRepository _repository;
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPracticeProvider() {
    _initRepository();
  }

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
  List<AudioExerciseEntity> get exercises => _exercises;

  List<AudioQuestionEntity> _questions = [];
  List<AudioQuestionEntity> get questions => _questions;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Trạng thái chơi nhạc
  PlayerState _playerState = PlayerState.stopped;
  PlayerState get playerState => _playerState;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Duration get duration => _duration;
  Duration get position => _position;

  // Trạng thái bài làm
  Map<int, int?> _selectedAnswers = {}; // {questionOrder: selectedOptionIndex}
  Map<int, int?> get selectedAnswers => _selectedAnswers;

  bool _isSubmitted = false;
  bool get isSubmitted => _isSubmitted;

  int _score = 0;
  int get score => _score;

  void init() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _playerState = state;
      notifyListeners();
    });

    _audioPlayer.onDurationChanged.listen((d) {
      _duration = d;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((p) {
      _position = p;
      notifyListeners();
    });
  }

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

  Future<void> pauseAudio() async => await _audioPlayer.pause();
  Future<void> resumeAudio() async => await _audioPlayer.resume();
  Future<void> seekAudio(Duration position) async => await _audioPlayer.seek(position);

  void selectAnswer(int questionOrder, int optionIndex) {
    if (_isSubmitted) return;
    _selectedAnswers[questionOrder] = optionIndex;
    notifyListeners();
  }

  void submitTest() {
    _isSubmitted = true;
    _score = 0;
    for (var q in _questions) {
      if (_selectedAnswers[q.order] == q.correctAnswer) {
        _score++;
      }
    }
    notifyListeners();
    _audioPlayer.pause();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
