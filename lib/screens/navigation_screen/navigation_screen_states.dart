import 'package:equatable/equatable.dart';

class NavigationScreenStates extends Equatable{
  @override
  List<Object> get props => [];
}

class ShowPageState extends NavigationScreenStates{
  @override
  List<Object> get props => [index];
  final int index;
  ShowPageState(this.index);
}