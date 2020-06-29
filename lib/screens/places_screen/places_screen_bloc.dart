import 'package:ShopQ/screens/login_screen/login_handler.dart';
import 'package:ShopQ/screens/places_screen/places_screen_events.dart';
import 'package:ShopQ/screens/places_screen/places_screen_states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Firestore _firestore = Firestore.instance;

class PlacesScreenBloc extends Bloc<PlacesScreenEvents, PlacesScreenStates> {
  LatLng initialPosition;

  @override
  PlacesScreenStates get initialState => Loading();

  @override
  Stream<PlacesScreenStates> mapEventToState(PlacesScreenEvents event) async* {
    if (event is CheckPermission) {
      var permission = await Geolocator().checkGeolocationPermissionStatus();
      if (permission == GeolocationStatus.denied ||
          permission == GeolocationStatus.disabled ||
          permission == GeolocationStatus.restricted) {
        yield NoPermission();
      } else {
        initialPosition = await _getUserLocation();
        List<Circle> circlesList = await _getCircles();
        yield ShowMap(initialPosition, circlesList);
      }
    }
  }
}

Future<LatLng> _getUserLocation() async {
  Position position = await Geolocator()
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  List<Placemark> placemark = await Geolocator()
      .placemarkFromCoordinates(position.latitude, position.longitude);
  return LatLng(position.latitude, position.longitude);
}

Future<List<Circle>> _getCircles() async {
  List<Circle> listOfCircles = [];
  var result = await _firestore
      .collection('shops')
      .document(LoginHandler.location)
      .get();
  var data = result.data;
  if(data['covid_cases'] != null){
    for(var element in data['covid_cases']){
      listOfCircles.add(Circle(
        circleId: CircleId('${LoginHandler.location}_$element'),
        fillColor: Color.fromRGBO(255, 0, 0, 0.2),
        radius: 100,
        strokeWidth: 3,
        strokeColor: Colors.red,
        center: LatLng(element.latitude, element.longitude),
      ),);
    }
  }

  print(data['covid_cases'][0].longitude);
  return listOfCircles;
}
