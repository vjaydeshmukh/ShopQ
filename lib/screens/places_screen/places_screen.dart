import 'dart:async';
import 'package:ShopQ/screens/places_screen/places_screen_bloc.dart';
import 'package:ShopQ/screens/places_screen/places_screen_events.dart';
import 'package:ShopQ/screens/places_screen/places_screen_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';

class PlacesScreen extends StatefulWidget {
  @override
  _PlacesScreenState createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  PlacesScreenBloc _placesScreenBloc;
  Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocProvider<PlacesScreenBloc>(
        create: (BuildContext context) => PlacesScreenBloc(),
        child: BlocBuilder<PlacesScreenBloc, PlacesScreenStates>(
          builder: (BuildContext context, PlacesScreenStates state) {
            _placesScreenBloc = BlocProvider.of<PlacesScreenBloc>(context);
            if (state is NoPermission) return _noPermissionBuilder();
            if(state is ShowMap) return _mapBuilder(state.initialPosition, state.circlesList);
            if (state is Loading) {
              _placesScreenBloc.add(CheckPermission());
              return _loadingBuilder();
            } else
              return Container();
          },
        ),
      ),
    );
  }

  Widget _mapBuilder(LatLng initialPosition, List<Circle> circlesList) => GoogleMap(
        mapToolbarEnabled: true,
        compassEnabled: true,
        buildingsEnabled: true,
        myLocationButtonEnabled: true,
        myLocationEnabled: true,
        zoomControlsEnabled: false,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        circles: circlesList.toSet(),
        initialCameraPosition: CameraPosition(
          target: initialPosition,
          zoom: 14.4746,
        ),
      );

  Widget _loadingBuilder() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 10,),
            Text('geolocation_should_be_turned_on').tr(context: context),
          ],
        ),
      );

  Widget _noPermissionBuilder() => Center(
        child: Text('no_permission_granted'),
      );
}
