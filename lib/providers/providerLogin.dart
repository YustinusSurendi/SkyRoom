import 'package:flutter/material.dart';
import 'package:sky_room/model/modelLogin.dart';

class UserProvider with ChangeNotifier {
  final List<ModelUser> _listUser = [
    ModelUser(email: 'alvannisdamai@gmail.com', password: 'alvannis')
  ];

  List<ModelUser> get allUser => _listUser;

  String _emailUserLogin = '';
  String get emailUserLogin => _emailUserLogin;

  void sedangLogin(username, email) {
    _emailUserLogin = email;
    notifyListeners();
  }

  ModelUser getUser(
    username,
    email,
  ) {
    return _listUser.firstWhere((user) => user.email == email);
  }

  void update(emailUser, ModelUser newData) {
    final index = _listUser.indexWhere((user) => user.email == emailUser);
    if (index >= 0) {
      _listUser[index] = newData;
      notifyListeners();
    } else {
      throw Exception('User not found');
    }
    notifyListeners();
  }

  void register(ModelUser user) {
    _listUser.add(user);
    notifyListeners();
  }

  String? _uid;
  String? get uid => _uid;
  void setUid(String uid) {
    _uid = uid;
    notifyListeners();
  }

  String? _username;
  String? get username => _username;
  void setUsername(String username) {
    _username = username;
    notifyListeners();
  }
}
