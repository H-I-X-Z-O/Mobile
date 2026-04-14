import 'package:flutter/material.dart';

// Import Screens từ các feature khác
import '../../../../core/constants/app_colors.dart';
import '../../../learning/presentation/screens/learning_dashboard_screen.dart';
import 'home_screen.dart';
import 'review_screen.dart';
import '../../../profile_progress/presentation/screens/profile_screen.dart';
import '../../../../core/extensions/context_extension.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final Set<int> _visitedPages = {0};

  late final List<Widget> _pages = [
    HomeScreen(onNavigate: _navigateToTab),
    LearningDashboardScreen(onNavigate: _navigateToTab),
    const ReviewScreen(),
    const ProfileScreen(),
  ];

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
      _visitedPages.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(_pages.length, (index) {
          if (_visitedPages.contains(index)) {
            return _pages[index];
          }
          return const SizedBox.shrink();
        }),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _visitedPages.add(index);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: context.l10n.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.school_outlined),
              activeIcon: Icon(Icons.school_rounded),
              label: context.l10n.topics,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history_outlined),
              activeIcon: Icon(Icons.history_rounded),
              label: context.l10n.review,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded),
              label: context.l10n.profile,
            ),
          ],
        ),
      ),
    );
  }
}