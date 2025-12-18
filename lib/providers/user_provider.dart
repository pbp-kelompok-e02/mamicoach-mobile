import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  bool _isCoach = false;

  String? get username => _username;
  bool get isCoach => _isCoach;

  // Initialize from SharedPreferences
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _isCoach = prefs.getBool('isCoach') ?? false;
    notifyListeners();
  }

  void setUsername(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    notifyListeners();
  }

  void setIsCoach(bool isCoach) async {
    _isCoach = isCoach;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isCoach', isCoach);
    notifyListeners();
  }

  void setUser(String username, bool isCoach) async {
    _username = username;
    _isCoach = isCoach;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setBool('isCoach', isCoach);
    notifyListeners();
  }

  void clearUser() async {
    _username = null;
    _isCoach = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('isCoach');
    notifyListeners();
  }
}
