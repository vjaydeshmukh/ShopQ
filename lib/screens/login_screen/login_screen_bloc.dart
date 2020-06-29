import 'package:ShopQ/screens/navigation_screen/navigation_screen.dart';
import 'package:ShopQ/screens/shop_home_screen/shop_home_screen.dart';
import 'package:ShopQ/screens/shop_login_screen/shop_login_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../main.dart';
import 'login_handler.dart';
import 'login_screen_events.dart';
import 'login_screen_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

LoginHandler _loginHandler = LoginHandler();
Firestore _firestore = Firestore.instance;

class LoginScreenBloc extends Bloc<LoginScreenEvents, LoginScreenStates> {
  String phoneNumber = '';
  bool isPhoneValid = false;

  @override
  LoginScreenStates get initialState => Loading();

  @override
  Stream<LoginScreenStates> mapEventToState(LoginScreenEvents event) async* {
    if (event is PhoneNumberEntered) {
      phoneNumber = event.phoneNumber;
      yield ShowPhoneEnterForm(phoneNumber.length == 12);
    }
    if (event is LoginPressed) {
      if (event.isValid) {
        var connectionState = await Connectivity().checkConnectivity();
        if (connectionState != ConnectivityResult.none) {
          isPhoneValid = false;
          _loginHandler.verifyPhoneNumber(phoneNumber);
          yield CodeSent();
        } else {
          await showDialog(
              context: navigatorKey.currentState.overlay.context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    'internet_error',
                  ).tr(context: context),
                  content: Text(
                    'internet_error_details',
                  ).tr(context: context),
                );
              });
        }
      } else {
        await showDialog(
            context: navigatorKey.currentState.overlay.context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'invalid_phone_number',
                ).tr(context: context),
                content: Text(
                  'invalid_phone_number_body',
                ).tr(context: context),
              );
            });
      }
    }
    if (event is LoginAsAShop) {
      navigatorKey.currentState.push(
        MaterialPageRoute(
          builder: (context) => ShopLoginScreen(),
        ),
      );
    }
    if (event is CheckUser) {
      bool isSignedIn = await _loginHandler.isSignedIn();
      var _auth = FirebaseAuth.instance;
      FirebaseUser currentUser = await _auth.currentUser();
      if (isSignedIn) {
        if (LoginHandler.phoneNumber != null && LoginHandler.phoneNumber.isNotEmpty) {
          var result = await _firestore
              .collection('users')
              .document(LoginHandler.phoneNumber)
              .get();
          var data = result.data;
          LoginHandler.location = data['location'];
          navigatorKey.currentState
              .pushNamedAndRemoveUntil(NavigationScreen.id, (route) => false);
        } else {
          var result = await _firestore
              .collection('workers')
              .document('kz')
              .collection('kz_workers')
              .where('email', isEqualTo: currentUser.email)
              .getDocuments();
          var document = result.documents.first;
          var data = document.data;
          LoginHandler.brn = data['brn'];
          LoginHandler.location = data['brn_location'];
          navigatorKey.currentState.pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => ShopHomeScreen(),
              ),
              (route) => false);
        }
      } else {
        yield ShowPhoneEnterForm(phoneNumber.length == 12);
      }
    }
  }
}
