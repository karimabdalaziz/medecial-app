import 'package:flutter/material.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    id: '',
    name: '',
    email: '',
    phone: '',
    dateOfBirth: DateTime(1990),
    gender: 'Male',
    appointmentsCount: 0,
    scansCount: 0,
  );

  UserModel get user => _user;

  void updateUser({
    required String name,
    required String email,
    required String phone,
  }) {
    _user = UserModel(
      id: _user.id,
      name: name,
      email: email,
      phone: phone,
      profileImageUrl: _user.profileImageUrl,
      dateOfBirth: _user.dateOfBirth,
      gender: _user.gender,
      appointmentsCount: _user.appointmentsCount,
      scansCount: _user.scansCount,
    );
    notifyListeners();
  }
}