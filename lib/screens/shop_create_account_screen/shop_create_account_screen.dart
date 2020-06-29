import 'package:ShopQ/screens/login_screen/login_handler.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import '../../constants.dart';

LoginHandler _loginHandler = LoginHandler();

class ShopCreateAccountScreen extends StatefulWidget {
  @override
  _ShopCreateAccountScreenState createState() =>
      _ShopCreateAccountScreenState();
}

class _ShopCreateAccountScreenState extends State<ShopCreateAccountScreen> {
  final _formKeyCreateAdministrator = GlobalKey<FormState>();
  String email, brn, password, location, urn;
  List<DropdownMenuItem> citiesDropdown = [];
  @override
  Widget build(BuildContext context) {
    for (var element in Constants.cities) {
      citiesDropdown.add(
        DropdownMenuItem(
          child: Text(element).tr(context: context),
          value: element,
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'shop_create',
        ).tr(context: context),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            child: Form(
              key: _formKeyCreateAdministrator,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) return tr('no_blank_field');
                      if (!value.contains("@")) return tr('valid_email');
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: tr('enter_your_email'),
                    ),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      urn = value;
                    },
                    validator: (value) {
                      if (value.length != 12) return tr('urn_12_digits');
                      return null;
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
                      brn = value;
                    },
                    validator: (value) {
                      if (value.length != 12) return tr('brn_12_digits');
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      hintText: tr('enter_your_bin'),
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: tr('enter_your_password'),
                    ),
                    onChanged: (value) {
                      password = value;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: tr('reenter_your_password'),
                    ),
                    validator: (value) {
                      if (value != password)
                        return tr('passwords_should_match');
                      return null;
                    },
                  ),
                  DropdownButtonFormField(
                    isExpanded: true,
                    validator: (value) {
                      if (value == null) return tr('choose_location');
                      return null;
                    },
                    hint: Text('choose_your_location').tr(context: context),
                    onChanged: (value) {
                      location = value;
                    },
                    items: citiesDropdown,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FlatButton(
                    onPressed: () {
                      if (_formKeyCreateAdministrator.currentState.validate()) {
                        _loginHandler.createAdminAccount(
                            email, brn, password, location, urn);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'create_account',
                    ).tr(context: context),
                  ),
                  SizedBox(
                    height: 10,
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
