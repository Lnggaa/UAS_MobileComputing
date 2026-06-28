import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  late Box<User> _box;
  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get hasAccount => _box.isNotEmpty;

  Future<void> init() async {
    _box = Hive.box<User>(AppUserBoxes.users);
    // Auto-login jika session tersimpan
    final sessionBox = Hive.box(AppUserBoxes.session);
    final savedName = sessionBox.get('loggedInUser');
    if (savedName != null) {
      _currentUser = _box.get(savedName);
    }
    notifyListeners();
  }

  Future<String?> register({
    required String name,
    required String password,
    String? photoPath,
  }) async {
    // Cek apakah nama sudah dipakai
    if (_box.containsKey(name)) {
      return 'Username already exists';
    }
    if (name.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }

    final user = User(
      name: name.trim(),
      password: password,
      photoPath: photoPath,
      hasSeenOnboarding: false,
    );
    await _box.put(name.trim(), user);
    _currentUser = user;

    // Simpan session
    final sessionBox = Hive.box(AppUserBoxes.session);
    await sessionBox.put('loggedInUser', name.trim());

    notifyListeners();
    return null; // null = sukses
  }

  Future<String?> login({
    required String name,
    required String password,
  }) async {
    final user = _box.get(name.trim());
    if (user == null) {
      return 'Account not found';
    }
    if (user.password != password) {
      return 'Wrong password';
    }

    _currentUser = user;

    // Simpan session
    final sessionBox = Hive.box(AppUserBoxes.session);
    await sessionBox.put('loggedInUser', name.trim());

    notifyListeners();
    return null;
  }

  Future<void> markOnboardingSeen() async {
    if (_currentUser != null) {
      _currentUser!.hasSeenOnboarding = true;
      await _currentUser!.save();
      notifyListeners();
    }
  }

  Future<void> updatePhoto(String photoPath) async {
    if (_currentUser != null) {
      _currentUser!.photoPath = photoPath;
      await _currentUser!.save();
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    final sessionBox = Hive.box(AppUserBoxes.session);
    await sessionBox.delete('loggedInUser');
    notifyListeners();
  }
}

class AppUserBoxes {
  static const String users = 'users';
  static const String session = 'session';
}
