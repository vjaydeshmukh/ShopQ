import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class NavigationScreenEvents extends Equatable{
  @override
  List<Object> get props => null;
}

class PageTapped extends NavigationScreenEvents{
  final int index;
  PageTapped({@required this.index});
}