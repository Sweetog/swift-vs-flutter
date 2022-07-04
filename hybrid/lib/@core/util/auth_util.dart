import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hybrid/@core/services/user_service.dart';

enum AuthResult {
  Unknown,
  Exists,
  DoesNotExist,
  Created,
  CreationError,
  SignInSuccess,
  NoProviderPassword,
  UserDbRecordCreationError,
  InvalidUsernameOrPassword,
  TooManyAttempts,
}

class AuthUtil {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  //dart singleton pattern
  // static final AuthUtil _authUtility = AuthUtil._internal();
  // AuthUtil._internal();
  // factory AuthUtil() => _authUtility;r
  static Future<bool> isSignedIn() async {
    return await _auth.currentUser() != null;
  }

  static Future<FirebaseUser> getCurrentUser() async {
    return await _auth.currentUser();
  }

  static Future<void> sendPasswordResetEmail(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  static Future<String> getDisplayName() async {
    var currentUser = await _auth.currentUser();

    if (currentUser == null) {
      return null;
    }

    return (currentUser.displayName != null &&
            currentUser.displayName.isNotEmpty)
        ? currentUser.displayName
        : currentUser.email;
  }

  static Future<DateTime> getCreatedDate() async {
    var currentUser = await _auth.currentUser();

    if (currentUser == null) {
      return null;
    }

    return DateTime.fromMillisecondsSinceEpoch(
        currentUser.metadata.creationTimestamp * 1000);
  }

  static Future<String> getBearerToken() async {
    var currentUser = await _auth.currentUser();

    if (currentUser == null) {
      return null;
    }

    return currentUser.getIdToken();
  }

  static Future<AuthResult> signIn(String email, String password) async {
    var providers = await _auth.fetchSignInMethodsForEmail(email: email);

    if (providers == null || providers.length <= 0) {
      return AuthResult.DoesNotExist;
    }

    var hasPasswordProvider = false;

    for (int i = 0; i < providers.length; i++) {
      if (providers[i] == AuthProviders.Password) {
        hasPasswordProvider = true;
      }
    }

    if (!hasPasswordProvider) {
      return AuthResult.NoProviderPassword;
    }

    try {
      var user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (user == null) {
        return AuthResult.DoesNotExist;
      }

      return AuthResult.SignInSuccess;
    } catch (e) {
      print(e.toString());
      print('====== type of e: ${e.runtimeType}');
      print('====== type of e.code: ${e.code.runtimeType}');
      if (e.code == 'ERROR_WRONG_PASSWORD') {
        return AuthResult.InvalidUsernameOrPassword;
      }
      if (e.code == 'ERROR_TOO_MANY_REQUESTS') {
        return AuthResult.TooManyAttempts;
      }
      return AuthResult.Unknown;
    }
  }

//add an auth message return type or enum
  static Future<AuthResult> createAccount(
      String name,
      String email,
      String password,
      String courseId,
      String memberNumber,
      String role) async {
    var providers = await _auth.fetchSignInMethodsForEmail(email: email);

    if (providers != null && providers.length > 0) {
      print(
          '==========AuthUtil.createAccount - $email account exits==========');
      return AuthResult.Exists;
    }

    try {
      var result = await UserService.createUser(
          name, email, password, courseId, memberNumber, role);

      if (result == UserStatus.UserCreationError) {
        print(
            '==========AuthUtil.createAccount - user db record creation failed for $email==========');
        return AuthResult.UserDbRecordCreationError;
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return AuthResult.Created;
    } catch (e) {
      print(e.toString());
      return AuthResult.CreationError;
    }
  }

  static signOut() {
    _auth.signOut();
  }
}

class AuthProviders {
  static const Password = "password";
}
