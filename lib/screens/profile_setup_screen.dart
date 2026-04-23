import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user_session.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _ageController = TextEditingController();
  String _selectedSkinType = 'Combination';
  final List<String> _skinTypes = ['Dry', 'Oily', 'Combination', 'Normal', 'Sensitive'];
  
  final List<String> _allConcerns = ['Acne', 'Aging', 'Dryness', 'Redness', 'Dark Spots', 'Pores'];
  final List<String> _selectedConcerns = [];

  bool _isLoading = false;

  void _handleSubmit() async {
    setState(() => _isLoading = true);
    
    try {
      final db = Provider.of<DatabaseService>(context, listen: false);
      final auth = Provider.of<AuthService>(context, listen: false);
      final uid = auth.user?.uid ?? 'mock_uid_${DateTime.now().millisecondsSinceEpoch}';

      final skinData = {
        'age': int.tryParse(_ageController.text) ?? 25,
        'skinType': _selectedSkinType,
        'concerns': _selectedConcerns,
      };

      await db.updateSkinProfile(uid, skinData);
      
      // Update local session just in case
      UserSession.login(
        name: UserSession.userName, 
        email: UserSession.email,
        admin: UserSession.isAdmin,
      );

      if (mounted) context.go('/home');
    } catch (e) {
      debugPrint("Failed to save profile: $e");
      if (mounted) context.go('/home'); // Go anyway on error for demo purposes
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text('Skin Profile', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 30)),
              const SizedBox(height: 8),
              Text(
                'Let\'s tailor GlowGuide AI to your unique skin needs.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 40),

              // Age
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'AGE',
                  hintText: 'e.g. 25',
                  prefixIcon: Icon(LucideIcons.calendar, size: 18),
                ),
              ),
              const SizedBox(height: 24),

              // Skin Type
              Text('SKIN TYPE', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _skinTypes.map((type) {
                  final isSelected = _selectedSkinType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedSkinType = type);
                    },
                    selectedColor: AppTheme.primaryContainer,
                    backgroundColor: AppTheme.surface,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.primary : AppTheme.secondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),

              // Concerns
              Text('SKIN CONCERNS', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _allConcerns.map((concern) {
                  final isSelected = _selectedConcerns.contains(concern);
                  return FilterChip(
                    label: Text(concern),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedConcerns.add(concern);
                        } else {
                          _selectedConcerns.remove(concern);
                        }
                      });
                    },
                    selectedColor: const Color(0xFFE1F5FE),
                    backgroundColor: AppTheme.surface,
                    checkmarkColor: const Color(0xFF0277BD),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFF0277BD) : AppTheme.secondary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 48),

              // Submit Button
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
                      : const Text(
                          'Complete Profile',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
