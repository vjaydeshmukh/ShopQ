import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesScreenStates extends Equatable{
  @override
  List<Object> get props => [];
}

class NoPermission extends PlacesScreenStates{}

class ShowMap extends PlacesScreenStates{
  final LatLng initialPosition;
  final List<Circle> circlesList;
  ShowMap(this.initialPosition, this.circlesList);
}

class Loading extends PlacesScreenStates{}