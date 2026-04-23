import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  static const _weekData = [0.4, 0.55, 0.48, 0.7, 0.65, 0.8, 0.75];
  static const _weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  static const _metrics = [
    {'label': 'Hydration', 'value': 0.78, 'color': 0xFF0288D1, 'trend': '+12%'},
    {'label': 'Clarity', 'value': 0.62, 'color': 0xFF2E7D32, 'trend': '+8%'},
    {'label': 'Elasticity', 'value': 0.45, 'color': 0xFF6A1B9A, 'trend': '+5%'},
    {'label': 'Oil Control', 'value': 0.55, 'color': 0xFFE65100, 'trend': '-3%'},
  ];

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
            title: Text('Skin Logger', style: Theme.of(context).textTheme.titleLarge),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Log Your Skin Health',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 6),
                  Text('Track daily changes and identify patterns.',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 28),

                  // Skin Diary photo grid
                  Text('SKIN DIARY', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _AddPhotoTile(),
                        _PhotoTile(date: 'Today', url: 'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=300'),
                        _PhotoTile(date: 'Apr 20', url: 'https://images.unsplash.com/photo-1512290923902-8a9f81dc2069?w=300'),
                        _PhotoTile(date: 'Apr 15', url: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=300'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Weekly Progress chart
                  Text('WEEKLY PROGRESS', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Overall Health Score',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 100,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(_weekData.length, (i) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        height: _weekData[i] * 80,
                                        decoration: BoxDecoration(
                                          gradient: AppTheme.primaryGradient,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(_weekDays[i],
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 11)),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Metrics
                  Text('SKIN METRICS', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      children: _metrics.asMap().entries.map((entry) {
                        final m = entry.value;
                        final isLast = entry.key == _metrics.length - 1;
                        final color = Color(m['color'] as int);
                        final value = m['value'] as double;
                        final trend = m['trend'] as String;
                        final isPositive = trend.startsWith('+');
                        return Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    width: 90,
                                    child: Text(m['label'] as String,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(fontWeight: FontWeight.w600, color: AppTheme.onSurface))),
                                Expanded(
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: color.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      FractionallySizedBox(
                                        widthFactor: value,
                                        child: Container(
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: color,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  trend,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: isPositive ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            if (!isLast)
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 14),
                                height: 1,
                                color: AppTheme.outlineVariant.withValues(alpha: 0.2),
                              ),
                          ],
                        );
                      }).toList(),
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

class _AddPhotoTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.outlineVariant.withValues(alpha: 0.5), style: BorderStyle.solid),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.plus, color: AppTheme.primary, size: 22),
          ),
          const SizedBox(height: 8),
          const Text('Add Photo', style: TextStyle(fontSize: 11, color: AppTheme.secondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final String date, url;
  const _PhotoTile({required this.date, required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        child: Text(date,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700)),
      ),
    );
  }
}
