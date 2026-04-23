class UserSession {
  static String _userName = '';
  static String _email = '';
  static bool _isAdmin = false;

  static String get userName => _userName;
  static String get email => _email;
  static bool get isAdmin => _isAdmin;

  static void login({required String name, required String email, bool admin = false}) {
    _userName = name.trim().isEmpty ? 'User' : name.trim();
    _email = email.trim();
    _isAdmin = admin;
  }

  static void signup({required String name, required String email}) {
    _userName = name.trim().isEmpty ? 'User' : name.trim();
    _email = email.trim();
    _isAdmin = name.trim().toLowerCase() == 'admin';
  }

  static void logout() {
    _userName = '';
    _email = '';
    _isAdmin = false;
  }
}
