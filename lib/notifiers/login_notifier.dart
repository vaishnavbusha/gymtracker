// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  late String email;
  late String password;

  LoginState({
    required this.email,
    required this.password,
  });

  LoginState copyWith({
    String? email,
    String? password,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  @override
  String toString() => 'LoginState(email: $email, password: $password)';
}

// ignore: subtype_of_sealed_class
class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier() : super(LoginState(email: '', password: ''));
  updateEmail(String value) {
    state.email = value;
    print(state.email);
  }

  updatePassword(String value) {
    state.password = value;
    print(state.password);
  }
}
