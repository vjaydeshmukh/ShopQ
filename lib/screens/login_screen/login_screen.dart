import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'login_screen_bloc.dart';
import 'login_screen_events.dart';
import 'login_screen_states.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'screens.login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginScreenBloc _loginScreenBloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(
          'authentication',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ).tr(context: context),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocProvider<LoginScreenBloc>(
        create: (BuildContext context) => LoginScreenBloc(),
        child: BlocBuilder<LoginScreenBloc, LoginScreenStates>(
          builder: (BuildContext context, LoginScreenStates state) {
            _loginScreenBloc = BlocProvider.of<LoginScreenBloc>(context);
            if (state is Loading) {
              _loginScreenBloc.add(CheckUser());
              return _loadingBuilder();
            }
            if (state is CodeSent) return _codeSentBuilder();
            if (state is ShowPhoneEnterForm)
              return _showEnterPhoneBuilder(state.isPhoneValid);
            else
              return Container();
          },
        ),
      ),
    );
  }

  Widget _loadingBuilder() => Center(
        child: CircularProgressIndicator(),
      );

  Widget _showEnterPhoneBuilder(bool isPhoneValid) => SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 0),
            child: ListView(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 37, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'phone_verification_body',
                        ).tr(context: context),
                        SizedBox(
                          height: 10,
                        ),
                        InternationalPhoneNumberInput(
                          hintText: tr('phone_number'),
                          countries: ['KZ'],
                          onInputChanged: (PhoneNumber number) {
                            _loginScreenBloc.add(
                              PhoneNumberEntered(
                                number.toString(),
                              ),
                            );
                          },
                          initialValue: PhoneNumber(isoCode: 'KZ'),
                          ignoreBlank: false,
                          autoValidate: false,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            _loginScreenBloc.add(LoginPressed(isPhoneValid));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(0.0, 1.0),
                                    blurRadius: 5.0,
                                  ),
                                ]),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(MdiIcons.loginVariant),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'authenticate',
                                  ).tr(context: context),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: (){
                            _loginScreenBloc.add(LoginAsAShop());
                          },
                          child: Text(
                            'login_as_a_shop',
                            style: TextStyle(color: Colors.blue),
                          ).tr(context: context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _codeSentBuilder() {
    return Center(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(),
              ),
              CircularProgressIndicator(),
              SizedBox(
                height: 20,
              ),
              Text(
                'number_is_being_verified',
              ).tr(context: context),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      'phone_number_should_be_on_this_device',
                      textAlign: TextAlign.center,
                    ).tr(context: context)
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
