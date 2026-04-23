import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../theme/app_theme.dart';
import '../models/user_session.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: Stack(
        children: [
          // Ambient glow blobs
          Positioned(
            top: -80, right: -60,
            child: _Blob(color: AppTheme.primaryContainer.withValues(alpha: 0.35), size: 280),
          ),
          Positioned(
            top: 200, left: -80,
            child: _Blob(color: const Color(0xFFE1F5FE).withValues(alpha: 0.5), size: 220),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeController,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
                children: [
                  // Header
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, ${UserSession.userName} 👋',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              UserSession.isAdmin ? '🛡️ Administrator' : 'Your skin is glowing today',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                      _AvatarBadge(name: UserSession.userName, isAdmin: UserSession.isAdmin),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Daily Progress Card
                  _GlassCard(
                    child: Consumer2<AuthService, DatabaseService>(
                      builder: (context, auth, db, child) {
                        final uid = auth.user?.uid ?? 'mock_uid';
                        return StreamBuilder<QuerySnapshot>(
                          stream: db.getRoutines(uid),
                          builder: (context, snapshot) {
                            List<Map<String, dynamic>> progressItems = [];
                            String routineId = '';
                            
                            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                              final data = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                              routineId = snapshot.data!.docs.first.id;
                              if (data.containsKey('steps')) {
                                progressItems = List<Map<String, dynamic>>.from(data['steps']);
                              }
                            } else {
                              // Fallback dummy for UI preview if no DB data
                              progressItems = [
                                {'text': 'Time for your morning serum', 'done': false},
                                {'text': 'Apply SPF 50', 'done': false},
                                {'text': 'Stay hydrated', 'done': false},
                              ];
                            }

                            final doneCount = progressItems.where((e) => e['done'] == true).length;
                            final totalCount = progressItems.isNotEmpty ? progressItems.length : 1;
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryContainer.withValues(alpha: 0.4),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(LucideIcons.clipboardCheck, color: AppTheme.primary, size: 18),
                                    ),
                                    const SizedBox(width: 10),
                                    Text('Daily Progress', style: Theme.of(context).textTheme.titleLarge),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                ...progressItems.asMap().entries.map((entry) {
                                  final i = entry.key;
                                  final item = entry.value;
                                  return _ChecklistItem(
                                    text: item['text'],
                                    done: item['done'] ?? false,
                                    onTap: () {
                                      if (routineId.isNotEmpty) {
                                        db.updateRoutineStep(uid, routineId, i, !(item['done'] ?? false));
                                      }
                                    },
                                  );
                                }),
                                const SizedBox(height: 12),
                                // Progress bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: doneCount / totalCount,
                                    backgroundColor: AppTheme.outlineVariant.withValues(alpha: 0.3),
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                                    minHeight: 6,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '$doneCount/${progressItems.length} tasks complete',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                                ),
                              ],
                            );
                          }
                        );
                      }
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Routines Section
                  Text('ROUTINES', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 14),
                  _RoutineCard(
                    title: 'Morning Routine',
                    subtitle: '3 steps · 8 min',
                    icon: LucideIcons.sun,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFF9C4), Color(0xFFFFCC80)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    iconColor: const Color(0xFFE65100),
                    onTap: () {},
                  ),
                  const SizedBox(height: 14),
                  _RoutineCard(
                    title: 'Night Routine',
                    subtitle: '4 steps · 12 min',
                    icon: LucideIcons.moon,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFE1F5FE), Color(0xFFCE93D8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    iconColor: const Color(0xFF4527A0),
                    onTap: () {},
                  ),
                  const SizedBox(height: 28),

                  // Daily Tip
                  Text('DAILY TIP', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.4)),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(LucideIcons.lightbulb, color: Colors.amber, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Layering', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
                              const SizedBox(height: 6),
                              Text(
                                'Apply your serum while your skin is still slightly damp from toner to lock in maximum hydration.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
        child: Container(color: Colors.transparent),
      ),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  final String name;
  final bool isAdmin;
  const _AvatarBadge({required this.name, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    return Stack(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(initials,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 20)),
          ),
        ),
        if (isAdmin)
          Positioned(
            right: 0, bottom: 0,
            child: Container(
              width: 16, height: 16,
              decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              child: const Icon(LucideIcons.shield, size: 10, color: Colors.white),
            ),
          ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.surface.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 0.5),
            boxShadow: AppTheme.cardShadow,
          ),
          child: child,
        ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String text;
  final bool done;
  final VoidCallback onTap;
  const _ChecklistItem({required this.text, required this.done, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: done ? AppTheme.primary : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: done ? AppTheme.primary : AppTheme.outlineVariant,
                  width: 2,
                ),
              ),
              child: done
                  ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 14),
            Text(
              text,
              style: TextStyle(
                fontSize: 15,
                color: done ? AppTheme.secondary : AppTheme.onSurface,
                decoration: done ? TextDecoration.lineThrough : null,
                decorationColor: AppTheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoutineCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final Color iconColor;
  final VoidCallback onTap;
  const _RoutineCard({
    required this.title, required this.subtitle, required this.icon,
    required this.gradient, required this.iconColor, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
