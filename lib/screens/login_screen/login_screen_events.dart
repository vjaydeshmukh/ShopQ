import 'package:equatable/equatable.dart';

class LoginScreenEvents extends Equatable{
  @override
  List<Object> get props => null;
}

class PhoneNumberEntered extends LoginScreenEvents{
  final String phoneNumber;
  PhoneNumberEntered(this.phoneNumber);
}

class LoginPressed extends LoginScreenEvents{
  final bool isValid;
  LoginPressed(this.isValid);
}

class LoginAsAShop extends LoginScreenEvents{}

class CheckUser extends LoginScreenEvents{}