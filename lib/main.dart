import 'package:flutter/material.dart';
import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'features/exercise/presentation/providers/exercise_provider.dart';
import 'features/profile_progress/presentation/providers/progress_provider.dart';
import 'features/profile_progress/presentation/providers/theme_provider.dart';
import 'features/learning/presentation/providers/learning_provider.dart';
import 'features/auth_shell/presentation/providers/auth_provider.dart';
import 'features/auth_shell/presentation/screens/login_screen.dart';
import 'features/auth_shell/presentation/screens/main_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/onboarding/presentation/screens/welcome_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, LearningProvider>(
          create: (_) => LearningProvider(),
          update: (_, auth, provider) => (provider ?? LearningProvider())..updateUser(auth.user?.id),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ExerciseProvider>(
          create: (_) => ExerciseProvider(),
          update: (_, auth, provider) => (provider ?? ExerciseProvider())..updateUser(auth.user?.id),
        ),
        ChangeNotifierProxyProvider<AuthProvider, ProgressProvider>(
          create: (_) => ProgressProvider(),
          update: (_, auth, provider) => (provider ?? ProgressProvider())..updateUser(auth.user?.id),
        ),
      ],
      // ĐIỂM SỬA 1: Đưa VocabUpApp ra ngoài cùng thay vì AppInitializer
      child: const VocabUpApp(),
    ),
  );
}

class VocabUpApp extends StatelessWidget {
  const VocabUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          title: 'VocabUp',
          debugShowCheckedModeBanner: false,
          theme: VocabUpTheme.light(),
          darkTheme: VocabUpTheme.dark(),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const AppInitializer(child: AuthWrapper()),
        );
      },
    );
  }
}

class AppInitializer extends StatefulWidget {
  final Widget child;
  const AppInitializer({super.key, required this.child});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  bool _initialized = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ).timeout(const Duration(seconds: 15));

      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _initialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      // ĐIỂM SỬA 3: Bỏ MaterialApp đi, chỉ trả về Scaffold vì lúc này đã nằm trong MaterialApp của VocabUpApp rồi
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (_error != null) {
      debugPrint('⚠️ Cảnh báo: Ứng dụng chạy với lỗi khởi tạo: $_error');
    }

    return widget.child;
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.authState == AuthState.loading ||
            authProvider.authState == AuthState.initial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        if (authProvider.authState == AuthState.authenticated) {
          return const MainShell();
        }

        return FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
              );
            }
            final hasSeenOnboarding = snapshot.data!.getBool('has_seen_onboarding') ?? false;
            if (!hasSeenOnboarding) {
              return const WelcomeScreen();
            }
            return const LoginScreen();
          },
        );
      },
    );
  }
}