// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list/app/core/database/sqlite_connection_factory.dart';

import 'package:todo_list/app/repositories/user/user_repository.dart';
import 'package:todo_list/exception/auth_exception.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final SqliteConnectionFactory? _sqliteConnectionFactory;

  UserRepositoryImpl(
      {required FirebaseAuth firebaseAuth,
      required SqliteConnectionFactory sqliteConnectionFactory})
      : _firebaseAuth = firebaseAuth,
        _sqliteConnectionFactory = sqliteConnectionFactory;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'email-already-exists') {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthException(
              message: 'Email ja utilizado, por favor escolha outro email');
        } else {
          throw AuthException(
              message:
                  'Voce se cadastrou com o Google, utilize este metodo de login');
        }
      } else {
        throw AuthException(message: e.message ?? 'Erro ao registrar usuario');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: e.message ?? 'Erro ao realizar login');
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: e.message ?? 'Erro ao realizar login');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      final loginMethods =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthException(
            message:
                'Cadastro realizado com o google, impossivel recuperar a senha');
      } else {
        throw AuthException(message: 'login nao encontrado');
      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);

      throw AuthException(message: "erro ao resetar senha");
    }
  }

  @override
  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
    final conn = await _sqliteConnectionFactory?.openConnection();
    await conn?.rawDelete('DELETE from todo');
    conn?.close();
  }

  @override
  // ignore: body_might_complete_normally_nullable
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
      final googleSignIn = GoogleSignIn();
      final googleUser = await googleSignIn.signIn();
      if (googleUser != null) {
        loginMethods =
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
        if (loginMethods.contains('password')) {
          throw AuthException(
              message:
                  'voce utilizou o email para cadastro, caso tenha esquecido sua senha, clique no link esqueceu sua senha');
        } else {
          final googleAuth = await googleUser.authentication;
          final firebaseCredencial = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
          var userCredencial =
              await _firebaseAuth.signInWithCredential(firebaseCredencial);
          return userCredencial.user;
        }
      }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'account-exists-with-different-credential') {
        throw AuthException(
            message:
                'voce se registou com os seguintes provedores: ${loginMethods?.join(',')} ');
      } else {
        throw AuthException(message: 'erro ao realizar login');
      }
    }
  }

  @override
  Future<void> updateName(String name) async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
