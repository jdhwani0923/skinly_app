import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';
import '../models/user_session.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: AppTheme.background,
            elevation: 0,
            title: Text('Profile', style: Theme.of(context).textTheme.titleLarge),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  // Avatar section
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        // Avatar with initials
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withValues(alpha: 0.6), width: 2),
                          ),
                          child: Center(
                            child: Text(
                              UserSession.userName.isNotEmpty ? UserSession.userName[0].toUpperCase() : 'U',
                              style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(UserSession.userName,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Text(
                          UserSession.email.isNotEmpty ? UserSession.email : 'glow@skincare.app',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                        ),
                        if (UserSession.isAdmin) ...[
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(LucideIcons.shield, size: 12, color: Colors.white),
                                SizedBox(width: 4),
                                Text('Administrator', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 20),
                        // Stats row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _Stat(label: 'ROUTINES', value: '12'),
                            _divider(),
                            _Stat(label: 'CONSISTENCY', value: '85%'),
                            _divider(),
                            _Stat(label: 'STREAK', value: '7d'),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Achievements
                  _SectionCard(
                    title: 'My Achievements',
                    icon: LucideIcons.award,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _Badge(icon: LucideIcons.zap, label: '7-Day Streak'),
                        _Badge(icon: LucideIcons.droplets, label: 'Hydration Hero'),
                        _Badge(icon: LucideIcons.sun, label: 'SPF Champion'),
                        _Badge(icon: LucideIcons.star, label: 'Routine Master'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // App Preferences
                  _SectionCard(
                    title: 'App Preferences',
                    icon: LucideIcons.settings,
                    child: Column(
                      children: [
                        _PrefTile(icon: LucideIcons.bell, label: 'Notifications', trailing: Switch(
                          value: true,
                          onChanged: (_) {},
                          activeThumbColor: AppTheme.primary,
                        )),
                        _PrefTile(icon: LucideIcons.moon, label: 'Dark Mode', trailing: Switch(
                          value: false,
                          onChanged: (_) {},
                          activeThumbColor: AppTheme.primary,
                        )),
                        _PrefTile(icon: LucideIcons.shield, label: 'Privacy Mode', trailing: Switch(
                          value: false,
                          onChanged: (_) {},
                          activeThumbColor: AppTheme.primary,
                        )),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Logout
                  GestureDetector(
                    onTap: () {
                      UserSession.logout();
                      context.go('/');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: AppTheme.cardShadow,
                      ),
                      child: const Row(
                        children: [
                          Icon(LucideIcons.logOut, color: Colors.redAccent, size: 20),
                          SizedBox(width: 14),
                          Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700, fontSize: 15)),
                        ],
                      ),
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

  Widget _divider() => Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.3));
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppTheme.primary),
              const SizedBox(width: 8),
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryContainer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppTheme.primaryContainer.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.primary),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: AppTheme.primary, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _PrefTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  const _PrefTile({required this.icon, required this.label, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.secondary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: Theme.of(context).textTheme.bodyLarge)),
          trailing,
        ],
      ),
    );
  }
}
