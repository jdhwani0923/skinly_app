import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/user_session.dart';
import '../services/auth_service.dart';
enum AuthMode { login, signup }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  AuthMode _mode = AuthMode.login;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (_mode == AuthMode.login && email.isEmpty) {
      _showError('Please enter your email');
      return;
    }
    if (_mode == AuthMode.signup && name.isEmpty) {
      _showError('Please enter your full name');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isLoading = false);

    if (_mode == AuthMode.login) {
      // Use email prefix as name if no name stored
      final displayName = email.contains('@') ? email.split('@')[0] : email;
      UserSession.login(
        name: displayName.isNotEmpty ? _capitalize(displayName) : 'User',
        email: email,
        admin: email.toLowerCase().contains('admin'),
      );
      
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        await authService.login(email, _passwordController.text);
      } catch (e) {
        debugPrint('Auth fallback: $e');
      }
      
      if (mounted) context.go('/home');
    } else {
      UserSession.signup(name: name, email: email);
      
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        await authService.signup(email, _passwordController.text);
      } catch (e) {
        debugPrint('Auth fallback: $e');
      }
      
      if (mounted) context.go('/setup');
    }
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                // Logo / Brand
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: AppTheme.ambientShadow,
                        ),
                        child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 36),
                      ),
                      const SizedBox(height: 20),
                      Text('Welcome to Glow',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 30)),
                      const SizedBox(height: 8),
                      Text(
                        'Your skin\'s personal clinical companion.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Mode Switcher
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      _modeTab('Sign In', AuthMode.login),
                      _modeTab('Sign Up', AuthMode.signup),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Name field (sign up only)
                if (_mode == AuthMode.signup) ...[
                  TextField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'FULL NAME',
                      hintText: 'e.g. Sarah Johnson',
                      prefixIcon: Icon(LucideIcons.user, size: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Email
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'EMAIL',
                    hintText: _mode == AuthMode.login ? 'your@email.com  (or "admin")' : 'your@email.com',
                    prefixIcon: const Icon(LucideIcons.mail, size: 18),
                  ),
                ),
                const SizedBox(height: 16),

                // Password
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'PASSWORD',
                    hintText: '••••••••',
                    prefixIcon: const Icon(LucideIcons.lock, size: 18),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? LucideIcons.eyeOff : LucideIcons.eye,
                        size: 18, color: AppTheme.secondary,
                      ),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),

                if (_mode == AuthMode.login) ...[
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text('Forgot password?',
                          style: TextStyle(color: AppTheme.primary, fontSize: 13)),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Submit Button with gradient
                Container(
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: AppTheme.primaryGradient,
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: AppTheme.ambientShadow,
                  ),
                  child: MaterialButton(
                    onPressed: _isLoading ? null : _handleSubmit,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9999)),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            _mode == AuthMode.login ? 'Sign In' : 'Create Account',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                  ),
                ),
                const SizedBox(height: 24),

                // Switch mode
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _mode == AuthMode.login
                            ? 'Don\'t have an account?'
                            : 'Already have an account?',
                        style: const TextStyle(color: AppTheme.secondary, fontSize: 14),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _mode = _mode == AuthMode.login ? AuthMode.signup : AuthMode.login;
                            _nameController.clear();
                          });
                          _fadeController.reset();
                          _fadeController.forward();
                        },
                        child: Text(
                          _mode == AuthMode.login ? 'Sign Up' : 'Sign In',
                          style: const TextStyle(
                              color: AppTheme.primary, fontWeight: FontWeight.w700, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),

                // Admin hint
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Tip: Sign up with name "admin" for admin access',
                    style: TextStyle(
                        color: AppTheme.secondary.withValues(alpha: 0.5),
                        fontSize: 11),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _modeTab(String label, AuthMode mode) {
    final isActive = _mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _mode = mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? AppTheme.surface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive ? AppTheme.cardShadow : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? AppTheme.primary : AppTheme.secondary,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}
