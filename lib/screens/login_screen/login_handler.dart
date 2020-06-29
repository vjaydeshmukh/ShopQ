import 'package:ShopQ/screens/login_screen/login_screen.dart';
import 'package:ShopQ/screens/navigation_screen/navigation_screen.dart';
import 'package:ShopQ/screens/shop_home_screen/shop_home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ShopQ/main.dart';
import 'package:easy_localization/easy_localization.dart';

Firestore _firestore = Firestore.instance;
FirebaseAuth _auth = FirebaseAuth.instance;

class LoginHandler {
  static String phoneNumber, location, brn;
  static FirebaseUser currentUser;
  final FirebaseAuth _firebaseAuth;

  LoginHandler({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(String phoneNumber) {
    _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void verificationCompleted(AuthCredential phoneAuthCredential) async {
    _firebaseAuth
        .signInWithCredential(phoneAuthCredential)
        .then((AuthResult value) async {
      if (value.user != null) {
        var result = await _firestore
            .collection('users')
            .document(value.user.phoneNumber)
            .get();
        if (!result.exists)
          await _firestore
              .collection('users')
              .document(value.user.phoneNumber)
              .setData({
            'location': '',
            'queue': '',
          });
        LoginHandler.phoneNumber = value.user.phoneNumber;
        LoginHandler.location = result.data['location'];
        navigatorKey.currentState
            .pushNamedAndRemoveUntil(NavigationScreen.id, (route) => false);
      } else {
        print('Not logged in');
      }
    });
  }

  void verificationFailed(AuthException error) {}

  void codeSent(String verificationId, [int forceResendingToken]) async {}

  void codeAutoRetrievalTimeout(String verificationId) {}

  Future<AuthResult> verifyAndLogin(
      String verificationId, String smsCode) async {
    AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: smsCode);
    return _firebaseAuth.signInWithCredential(authCredential);
  }

  Future<FirebaseUser> getUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    navigatorKey.currentState
        .pushNamedAndRemoveUntil(LoginScreen.id, (route) => false);
  }

  Future<bool> isSignedIn() async {
    final currentUser = await _firebaseAuth.currentUser();
    if (currentUser != null) LoginHandler.phoneNumber = currentUser.phoneNumber;
    return currentUser != null;
  }

  void logInAdminAccount(String urn, password) async {
    showDialog(
      context: navigatorKey.currentState.overlay.context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'processing',
        ).tr(context: context),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
    var checkUser = await _firestore
        .collection('workers')
        .document('kz')
        .collection('kz_workers')
        .document(urn)
        .get();
    if (checkUser.exists) {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: checkUser.data['email'], password: password);
      if (result.user != null) {
        var data = checkUser.data;
        LoginHandler.location = location;
        LoginHandler.brn = brn;
        navigatorKey.currentState.pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => ShopHomeScreen()),
          (route) => false,
        );
      } else {
        Navigator.pop(navigatorKey.currentState.overlay.context);
        showDialog(
          context: navigatorKey.currentState.overlay.context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              'error',
            ).tr(context: context),
            content: Text(
              'account_create_error',
            ).tr(context: context),
          ),
        );
      }
    } else {
      Navigator.pop(navigatorKey.currentState.overlay.context);
      showDialog(
        context: navigatorKey.currentState.overlay.context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(
            'error',
          ).tr(context: context),
          content: Text(
            'no_user_found',
          ).tr(context: context),
        ),
      );
    }
  }

  void createAdminAccount(String email, String brn, String password,
      String location, String urn) async {
    showDialog(
      context: navigatorKey.currentState.overlay.context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(
          'processing',
        ).tr(context: context),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
    var businessSearch = await _firestore
        .collection('shops')
        .document(location)
        .collection('food_shops')
        .document(brn)
        .get();
    if (businessSearch.exists) {
      List urnSearch = await businessSearch.data['workers_urn'];
      if (urnSearch == null) urnSearch = [];
      if (urnSearch.contains(urn)) {
        AuthResult result = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        if (result.user != null) {
          var checkUser = await _firestore
              .collection('workers')
              .document('kz')
              .collection('kz_workers')
              .document(urn)
              .get();
          if (!checkUser.exists) {
            await _firestore
                .collection('workers')
                .document('kz')
                .collection('kz_workers')
                .document(urn)
                .setData({
              'brn': brn,
              'brn_location': location,
              'email': email,
            });
          } else {
            await _firestore
                .collection('workers')
                .document('kz')
                .collection('kz_workers')
                .document(urn)
                .updateData({
              'brn': brn,
              'email': email,
            });
          }
          LoginHandler.location = location;
          LoginHandler.brn = brn;
          navigatorKey.currentState.pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (BuildContext context) => ShopHomeScreen(),
            ),
            (route) => false,
          );
        } else {
          Navigator.pop(navigatorKey.currentState.overlay.context);
          showDialog(
            context: navigatorKey.currentState.overlay.context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(
                'error',
              ).tr(context: context),
              content: Text(
                'account_create_error',
              ).tr(context: context),
            ),
          );
        }
      } else {
        Navigator.pop(navigatorKey.currentState.overlay.context);
        showDialog(
          context: navigatorKey.currentState.overlay.context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(
              'error',
            ).tr(context: context),
            content: Text(
              'no_email_in_business',
            ).tr(context: context),
          ),
        );
      }
    } else {
      Navigator.pop(navigatorKey.currentState.overlay.context);
      showDialog(
          context: navigatorKey.currentState.overlay.context,
          builder: (BuildContext context) => AlertDialog(
                title: Text(
                  'error',
                ).tr(context: context),
                content: Text(
                  'no_business_in_database',
                ).tr(context: context),
              ));
    }
  }
}
