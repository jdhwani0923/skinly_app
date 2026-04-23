import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

class DetectionScreen extends StatefulWidget {
  const DetectionScreen({super.key});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _startScan() async {
    setState(() => _scanning = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Analyzing your skin...'),
          backgroundColor: AppTheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _scanning = false);
    if (mounted) context.push('/recommendations');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Simulated camera background
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1512290923902-8a9f81dc2069?w=800',
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.35),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      _CircleIconButton(
                        icon: LucideIcons.x,
                        onTap: () => context.pop(),
                      ),
                      const Spacer(),
                      const Column(
                        children: [
                          Text('AI Skin Scan',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                          Text('Precision Detection',
                              style: TextStyle(color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      const Spacer(),
                      _CircleIconButton(icon: LucideIcons.helpCircle, onTap: () {}),
                    ],
                  ),
                ),

                const Spacer(),

                // Scanning circle frame
                AnimatedBuilder(
                  animation: _pulseAnim,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scanning ? _pulseAnim.value : 1.0,
                      child: child,
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer glow ring
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _scanning
                                ? AppTheme.primaryContainer.withValues(alpha: 0.8)
                                : Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      // Main scanning circle
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _scanning ? AppTheme.primaryContainer : Colors.white,
                            width: 2.5,
                          ),
                          boxShadow: _scanning
                              ? [
                                  BoxShadow(
                                    color: AppTheme.primaryContainer.withValues(alpha: 0.5),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  )
                                ]
                              : null,
                        ),
                      ),
                      // Scan guide lines (corners)
                      ..._buildCorners(),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Text(
                  'Align your face within the circle for the best results.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                // Controls
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _ControlButton(icon: LucideIcons.image, label: 'Gallery', onTap: () {}),
                      // Main shutter button
                      GestureDetector(
                        onTap: _scanning ? null : _startScan,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: _scanning ? null : AppTheme.primaryGradient,
                            color: _scanning ? Colors.white24 : null,
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: _scanning
                                ? null
                                : [
                                    BoxShadow(
                                      color: AppTheme.primaryContainer.withValues(alpha: 0.6),
                                      blurRadius: 20,
                                      spreadRadius: 2,
                                    ),
                                  ],
                          ),
                          child: _scanning
                              ? const Center(
                                  child: SizedBox(
                                    width: 28,
                                    height: 28,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  ),
                                )
                              : const Icon(LucideIcons.scan, color: Colors.white, size: 30),
                        ),
                      ),
                      _ControlButton(icon: LucideIcons.zap, label: 'Flash', onTap: () {}),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCorners() {
    const size = 30.0;
    const weight = 3.0;
    final color = _scanning ? AppTheme.primaryContainer : Colors.white;
    return [
      Positioned(top: 10, left: 10, child: _Corner(size: size, weight: weight, color: color, top: true, left: true)),
      Positioned(top: 10, right: 10, child: _Corner(size: size, weight: weight, color: color, top: true, left: false)),
      Positioned(bottom: 10, left: 10, child: _Corner(size: size, weight: weight, color: color, top: false, left: true)),
      Positioned(bottom: 10, right: 10, child: _Corner(size: size, weight: weight, color: color, top: false, left: false)),
    ];
  }
}

class _Corner extends StatelessWidget {
  final double size, weight;
  final Color color;
  final bool top, left;
  const _Corner({required this.size, required this.weight, required this.color, required this.top, required this.left});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: CustomPaint(painter: _CornerPainter(color: color, weight: weight, top: top, left: left)),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double weight;
  final bool top, left;
  _CornerPainter({required this.color, required this.weight, required this.top, required this.left});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = weight..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    final startX = left ? 0.0 : size.width;
    final endX = left ? size.width : 0.0;
    final startY = top ? 0.0 : size.height;
    final endY = top ? size.height : 0.0;
    canvas.drawLine(Offset(startX, startY), Offset(endX, startY), paint);
    canvas.drawLine(Offset(startX, startY), Offset(startX, endY), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ControlButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
