import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class RecommendationsScreen extends StatelessWidget {
  const RecommendationsScreen({super.key});

  static const _products = [
    {
      'name': 'Hydrating Rose Mist',
      'brand': 'GLOW LABS',
      'desc': 'Soothes irritation and restores pH balance after cleansing.',
      'match': '98%',
      'tag': 'Toner',
    },
    {
      'name': 'Peptide Elixir',
      'brand': 'DERMASCIENCE',
      'desc': 'Targets fine lines and supports collagen production overnight.',
      'match': '95%',
      'tag': 'Serum',
    },
    {
      'name': 'Cloud Whip',
      'brand': 'VELVET SKIN',
      'desc': 'Lightweight moisturizer with hyaluronic acid for all-day protection.',
      'match': '92%',
      'tag': 'Moisturizer',
    },
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
            title: Text('Smart Recommendations', style: Theme.of(context).textTheme.titleLarge),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Personalized Solutions',
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Curated dermatological paths based on your skin\'s unique cycle.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  // Hydration insight chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5FE),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: [
                        const Icon(LucideIcons.droplets, color: Color(0xFF0277BD), size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Drinking 2L of water improves skin elasticity and cellular turnover.',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF01579B), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  Text('RECOMMENDED PRODUCTS', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 14),
                  ..._products.map((p) => _ProductCard(product: p)),

                  const SizedBox(height: 32),
                  Text('MORNING ROUTINE', style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: AppTheme.cardShadow,
                    ),
                    child: Column(
                      children: [
                        _RoutineStep(step: '1', name: 'Hydrating Rose Mist', category: 'Tone & Prep', done: true),
                        _divider(),
                        _RoutineStep(step: '2', name: 'Peptide Elixir', category: 'Treatment', done: true),
                        _divider(),
                        _RoutineStep(step: '3', name: 'Cloud Whip', category: 'Moisturize', done: false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // CTA
                  Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(9999),
                      boxShadow: AppTheme.ambientShadow,
                    ),
                    child: MaterialButton(
                      onPressed: () {},
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.calendar, color: Colors.white, size: 18),
                          SizedBox(width: 10),
                          Text('Add All to Calendar',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
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

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 1,
      color: AppTheme.outlineVariant.withValues(alpha: 0.3),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, String> product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          // Product icon
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(LucideIcons.flaskConical, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['brand']!,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(fontSize: 10)),
                Text(product['name']!,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16)),
                const SizedBox(height: 4),
                Text(product['desc']!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(product['match']!,
                    style: const TextStyle(color: AppTheme.primary, fontSize: 11, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(product['tag']!,
                    style: TextStyle(color: AppTheme.secondary, fontSize: 10, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoutineStep extends StatelessWidget {
  final String step, name, category;
  final bool done;
  const _RoutineStep({required this.step, required this.name, required this.category, required this.done});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: done ? AppTheme.primary : AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(10),
          ),
          child: done
              ? const Icon(LucideIcons.check, color: Colors.white, size: 18)
              : Center(child: Text(step, style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.secondary))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
              Text(category, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12)),
            ],
          ),
        ),
        Icon(done ? LucideIcons.checkCircle2 : LucideIcons.circle,
            size: 20, color: done ? AppTheme.primary : AppTheme.outlineVariant),
      ],
    );
  }
}
