import 'package:flutter/material.dart';
import 'package:ticket/api/user.dart';
import 'package:ticket/model/user.dart';

class UserVM extends ChangeNotifier {
  User? user;

  void setUserInfo(User user) {
    this.user = user;
    notifyListeners();
  }

  Future<String> login(
      {required String email, required String password}) async {
    var message = await userApi.login(email: email, password: password);
    user = await userApi.info();
    notifyListeners();
    return message;
  }

  reset() {
    user = null;
    notifyListeners();
  }
}
