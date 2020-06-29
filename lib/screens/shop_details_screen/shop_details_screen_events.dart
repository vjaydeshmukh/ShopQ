import 'package:equatable/equatable.dart';

class ShopDetailsScreenEvents extends Equatable{
  @override
  List<Object> get props => null;
}

class TimeChosen extends ShopDetailsScreenEvents{
  final DateTime chosenTime;
  TimeChosen(this.chosenTime);
}

class ProductsListEdited extends ShopDetailsScreenEvents{
  final String productsList;
  ProductsListEdited(this.productsList);
}

class StandInQueue extends ShopDetailsScreenEvents{
  final String brn;
  StandInQueue(this.brn);
}