import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:zak_mobile_app/main.dart';

import 'package:zak_mobile_app/networking/constants.dart';
import 'package:zak_mobile_app/networking/http_requests.dart';

class AuthenticationViewModel with ChangeNotifier {
  String _accessToken;
  String _userID;
  String _phoneNumber;
  final _storage = FlutterSecureStorage();

  String get token {
    return _accessToken;
  }

  String get userID {
    return _userID;
  }

  String get phoneNumber {
    return _phoneNumber;
  }

  Future<bool> isUserSignedIn() async {
    _accessToken = await _storage.read(key: accessTokenKey);
    _userID = await _storage.read(key: userIDKey);
    _phoneNumber = await _storage.read(key: userNameKey);
    final expireTimeEpoch = await _storage.read(key: expiryKey);
    if (expireTimeEpoch != null) {
      final expireTime = DateTime.fromMicrosecondsSinceEpoch(
          (int.parse(expireTimeEpoch) * 1000000));
      if (_accessToken == null ||
          _userID == null ||
          _phoneNumber == null ||
          expireTime == null) {
        return false;
      } else {
        if (expireTime.isAfter(DateTime.now())) {
          return true;
        }
        signOutUser();
        return false;
      }
    }
    return false;
  }

  void _storeAccessToken(String accessToken) async {
    _accessToken = accessToken;
    await _storage.write(key: accessTokenKey, value: accessToken);
  }

  void _storeUserDetails(
      String userID, String phoneNumber, int expireTimeEpoch) async {
    _phoneNumber = phoneNumber;
    _userID = userID;
    await _storage.write(key: userIDKey, value: userID);
    await _storage.write(key: userNameKey, value: phoneNumber);
    await _storage.write(key: expiryKey, value: expireTimeEpoch.toString());
  }

  void _deleteAccessToken() {
    _accessToken = null;
  }

  String _decodeToken(String encodedToken) {
    final normalizedSource = base64Url.normalize(encodedToken);
    return utf8.decode(base64Url.decode(normalizedSource));
  }

  void _decodeTokenAndStoreDetails(dynamic jwtTokenObject) {
    final responseBody = json.decode(jwtTokenObject);
    final token = responseBody[tokenKey];
    final decodedToken = _decodeToken(token.split('.')[1]);
    final decodedJWT = json.decode(decodedToken);
    _storeUserDetails(decodedJWT[userIDKey].toString(),
        decodedJWT[userNameKey].toString(), decodedJWT[expiryKey]);
    _storeAccessToken(responseBody[tokenKey]);
  }

  Future<SignInConfirmed> signInUser(
      {String password, String phoneNumber}) async {
    var didSucceed = false;
    var isUserConfirmed;
    final body = {
      passwordKey: password,
      mobileKey: phoneNumber,
    };
    final response = await postRequest(
        signUp: true,
        accessToken: _accessToken,
        api: loginKey,
        body: body,
        successStatusCode: 200);
    if (response.didSucceed) {
      isUserConfirmed = true;
      didSucceed = true;
      userId = json.decode(response.object)['user_id'].toString();
      _decodeTokenAndStoreDetails(response.object);
    } else {
      try {
        final responseBody = json.decode(response.object);
        if (responseBody[verifiedKey] != null) {
          if (responseBody[verifiedKey][0] == 'False') {
            isUserConfirmed = false;
          }
        }
      } catch (error) {
        didSucceed = false;
      }
    }
    return SignInConfirmed(
        isSuccessful: didSucceed,
        isUserConfirmed: isUserConfirmed,
        message: response.responseMessage);
  }

  Future<Response> signUpUser({
    @required String phoneNumber,
    @required String password,
  }) async {
    final body = {
      mobileKey: phoneNumber,
      passwordKey: password,
    };
    final response = await postRequest(
        signUp: true, api: signupKey, body: body, successStatusCode: 200);
    return response;
  }

  void signOutUser() async {
    await _deleteAccessToken();
    await _storage.deleteAll();
  }

  Future<Response> sendOTP(String toPhoneNumber) async {
    final body = {mobileKey: toPhoneNumber};
    final response = await postRequest(
      api: generateOTPKey,
      signUp: true,
      body: body,
      successStatusCode: 200,
    );
    return response;
  }

  Future<Response> forgotPassword(
      {String phoneNumber, String otp, String password}) async {
    final body = {mobileKey: phoneNumber, otpKey: otp, passwordKey: password};
    final response = await postRequest(
      api: forgotPasswordKey,
      body: body,
      signUp: true,
      successStatusCode: 200,
    );
    return response;
  }

  Future<Response> verifyOTP({String phoneNumber, String otp}) async {
    final body = {mobileKey: phoneNumber, otpKey: otp};
    final response = await postRequest(
      api: verifyOTPKey,
      body: body,
      signUp: true,
      successStatusCode: 200,
    );
    if (response.didSucceed) {
      _decodeTokenAndStoreDetails(response.object);
    }

    return response;
  }
}

class SignInConfirmed {
  final bool isUserConfirmed;
  final bool isSuccessful;
  final String message;

  SignInConfirmed(
      {this.isUserConfirmed,
      this.isSuccessful = false,
      this.message = 'Something went wrong. Please try again'});
}
