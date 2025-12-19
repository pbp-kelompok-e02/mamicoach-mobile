import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? _username;
  bool _isCoach = false;
  String? _profilePictureUrl;

  String? get username => _username;
  bool get isCoach => _isCoach;
  String? get profilePicture => _profilePictureUrl;

  // Initialize from SharedPreferences
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    _isCoach = prefs.getBool('isCoach') ?? false;
    _profilePictureUrl = prefs.getString('profilePicture');
    notifyListeners();
  }

  void setUser(String username, bool isCoach, {String? profilePicture}) async {
    _username = username;
    _isCoach = isCoach;
    _profilePictureUrl = profilePicture;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setBool('isCoach', isCoach);
    if (profilePicture != null) {
      await prefs.setString('profilePicture', profilePicture);
    } else {
      await prefs.remove('profilePicture');
    }
    notifyListeners();
  }

  void clearUser() async {
    _username = null;
    _isCoach = false;
    _profilePictureUrl = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('isCoach');
    await prefs.remove('profilePicture');
    notifyListeners();
  }
}
