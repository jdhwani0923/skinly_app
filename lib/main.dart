import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/detection_screen.dart';
import 'screens/recommendations_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/profile_setup_screen.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint("Firebase initialization failed, running in mock mode: $e");
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        Provider(create: (_) => DatabaseService()),
      ],
      child: const GlowGuideApp(),
    ),
  );
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final _router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    // Auth — no shell
    GoRoute(
      path: '/',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const LoginScreen(),
    ),
    // Profile Setup - no shell
    GoRoute(
      path: '/setup',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const ProfileSetupScreen(),
    ),
    // Camera — full-screen, no bottom bar
    GoRoute(
      path: '/detection',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (_, __) => const DetectionScreen(),
    ),
    // Main app shell with persistent bottom nav
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => _AppShell(child: child, state: state),
      routes: [
        GoRoute(
          path: '/home',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: '/analytics',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (_, __) => const AnalyticsScreen(),
        ),
        GoRoute(
          path: '/recommendations',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (_, __) => const RecommendationsScreen(),
        ),
        GoRoute(
          path: '/profile',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

class _AppShell extends StatelessWidget {
  final Widget child;
  final GoRouterState state;
  const _AppShell({required this.child, required this.state});

  int _selectedIndex(String path) {
    if (path == '/home') return 0;
    if (path == '/analytics') return 1;
    if (path == '/recommendations') return 2;
    if (path == '/profile') return 3;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0: context.go('/home'); break;
      case 1: context.go('/recommendations'); break; // Routine
      case 2: context.go('/analytics'); break; // Progress
      case 3: context.go('/profile'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(state.uri.path);

    return Scaffold(
      body: child,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/detection'),
        backgroundColor: AppTheme.primary,
        elevation: 6,
        shape: const CircleBorder(),
        child: Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: const Icon(LucideIcons.camera, color: Colors.white, size: 26),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF8BBD0).withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: BottomAppBar(
          color: AppTheme.surface,
          elevation: 0,
          shape: const CircularNotchedRectangle(),
          notchMargin: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: LucideIcons.home, label: 'Home', index: 0, selectedIndex: selectedIndex, onTap: _onTap),
              _NavItem(icon: LucideIcons.sparkles, label: 'Routine', index: 1, selectedIndex: selectedIndex == 2 ? 1 : selectedIndex, onTap: _onTap),
              const SizedBox(width: 56), // FAB notch
              _NavItem(icon: LucideIcons.fileEdit, label: 'Progress', index: 2, selectedIndex: selectedIndex == 1 ? 2 : selectedIndex, onTap: _onTap),
              _NavItem(icon: LucideIcons.user, label: 'Profile', index: 3, selectedIndex: selectedIndex, onTap: _onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index, selectedIndex;
  final void Function(BuildContext, int) onTap;
  const _NavItem({required this.icon, required this.label, required this.index, required this.selectedIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isSelected = index == selectedIndex;
    return GestureDetector(
      onTap: () => onTap(context, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: isSelected ? BoxDecoration(
          color: AppTheme.primaryContainer.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(12),
        ) : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22,
                color: isSelected ? AppTheme.primary : AppTheme.secondary.withValues(alpha: 0.5)),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppTheme.primary : AppTheme.secondary.withValues(alpha: 0.5),
                )),
          ],
        ),
      ),
    );
  }
}

class GlowGuideApp extends StatelessWidget {
  const GlowGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GlowGuide AI',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}
