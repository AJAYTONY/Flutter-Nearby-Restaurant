import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_restaurants/widget/app_header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearByRestaurantOnMap extends StatefulWidget {
  const NearByRestaurantOnMap({Key? key}) : super(key: key);

  @override
  _NearByRestaurantOnMapState createState() => _NearByRestaurantOnMapState();
}

class _NearByRestaurantOnMapState extends State<NearByRestaurantOnMap> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Align(
              alignment: Alignment.center,
              child: AppHeader(text: 'NearBy Restaurants'),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // SizedBox(
                  //   child: Text('$location \n$address'),
                  // ),
                  Spacer(),
                  InkWell(
                    child: const Icon(
                      Icons.menu,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      print('Menu');
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  InkWell(
                    child: Icon(
                      Icons.my_location,
                      color: Colors.indigo.shade700,
                    ),
                    onTap: () async {
                      print('Nearby Restaurants');
                      // getNearByPlaces();
                      // setRestaurantInList(context);
                    },
                  ),
                  // IconButton(onPressed: (){}, icon: Icon(Icons.menu)),
                  // IconButton(onPressed: (){}, icon: Icon(Icons.my_location)),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Divider(
              color: Colors.grey.shade900,
            ),
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 11.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
