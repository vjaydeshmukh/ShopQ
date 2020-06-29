import 'package:ShopQ/screens/login_screen/login_handler.dart';
import 'package:ShopQ/screens/shop_create_account_screen/shop_create_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

class ShopLoginScreen extends StatefulWidget {
  @override
  _ShopLoginScreenState createState() => _ShopLoginScreenState();
}

class _ShopLoginScreenState extends State<ShopLoginScreen> {
  var _formAdminLoginKey = GlobalKey<FormState>();
  String urn, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: Form(
              key: _formAdminLoginKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.length != 12) return tr('urn_12_digits');
                      return null;
                    },
                    onChanged: (value) {
                      urn = value;
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      hintText: tr('enter_your_iin'),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: tr('enter_your_password'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    elevation: 5,
                    color: Colors.white,
                    onPressed: () {
                      if (_formAdminLoginKey.currentState.validate()) {
                        LoginHandler().logInAdminAccount(urn, password);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'login',
                    ).tr(context: context),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShopCreateAccountScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'create_account',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue),
                    ).tr(context: context),
                  ),
                  Expanded(child: Container()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
