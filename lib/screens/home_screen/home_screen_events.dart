import 'package:equatable/equatable.dart';

class HomeScreenEvents extends Equatable{
  @override
  List<Object> get props => null;
}

class SearchChanged extends HomeScreenEvents{
  final String shopSearch;
  SearchChanged(this.shopSearch);
}

class FetchShopsList extends HomeScreenEvents{}

class LocationChanged extends HomeScreenEvents{
  final String location;
  LocationChanged(this.location);
}

class SaveLocation extends HomeScreenEvents{

}

class RemoveFromQueue extends HomeScreenEvents{
  final String brn, time;
  RemoveFromQueue(this.brn, this.time);
}

class ChangeLocation extends HomeScreenEvents{}