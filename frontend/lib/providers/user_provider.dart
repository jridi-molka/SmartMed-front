import 'package:flutter/foundation.dart';

import '../core/network/api_exception.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class UserProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  String? _error;
  bool _isLoading = false;

  User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;

  Future<void> loadUser() async {
    if (_user != null) return;

    _isLoading = true;
    _error = null;

    try {
      _user = await _authService.getMe();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (_) {
      _error = 'Impossible de joindre le serveur';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _user = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}