import 'package:equatable/equatable.dart';

class LoginScreenStates extends Equatable{
  @override
  List<Object> get props => [];
}

class Loading extends LoginScreenStates{}

class ShowPhoneEnterForm extends LoginScreenStates{
  @override
  List<Object> get props => [isPhoneValid];
  final bool isPhoneValid;

  ShowPhoneEnterForm(this.isPhoneValid);
}

class Uninitialized extends LoginScreenStates{}

class Unauthenticated extends LoginScreenStates{
  @override
  List<Object> get props => [isPhoneValid];
  final bool isPhoneValid;

  Unauthenticated(this.isPhoneValid);
}

class Authenticated extends LoginScreenStates{}

class CodeSent extends LoginScreenStates{}