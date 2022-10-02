import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearby_restaurants/models/NearByRestaurantResponse.dart';
import 'package:flutter_nearby_restaurants/screens/near_by_restaurant_on_map.dart';
import 'package:flutter_nearby_restaurants/utils/constant.dart';
import 'package:flutter_nearby_restaurants/widget/app_header.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;

class NearByRestaurant extends StatefulWidget {
  const NearByRestaurant({Key? key}) : super(key: key);

  @override
  _NearByRestaurantState createState() => _NearByRestaurantState();
}

class _NearByRestaurantState extends State<NearByRestaurant> {
  String location = 'Null, Press Button';
  String address = 'search';
  String latitude = "";
  String longitude = "";
  bool isLoading = true;
  late NearbyPlacesResponse? nearByPlacesResponse2;

  late Future<NearbyPlacesResponse> nearByPlaces;

  // NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();
  //  Future<NearbyPlacesResponse>? nearByPlacesResponse;

  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    address =
        '${place.street}, ${place.thoroughfare},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {});
  }

  @override
  void initState() {
    getLocation();
    super.initState();
  }

  void getLocation() async {
    print('Get Live Location');
    Position position = await _getGeoLocationPosition();
    latitude = '${position.latitude}';
    longitude = '${position.longitude}';
    location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
    GetAddressFromLatLong(position);

    nearByPlacesResponse2 = await getNearByPlaces();
    print("ABCD  :::  ${nearByPlacesResponse2?.results!.length}");
    isLoading = false;

    setState(() {});

    //nearByPlaces = APIManager().getNearbyPlacesResponseData(latitude,longitude);
    //getNearByPlaces();
  }

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
                  Flexible(
                    child: Text('$location \n$address'),
                  ),
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
            isLoading
                ? const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                : setRestaurantInList(context)
          ],
        ),
      ),
    );
  }

  Future<NearbyPlacesResponse?> getNearByPlaces() async {
    print("LAT  ::" + latitude);
    print("LONG ::" + longitude);

    var nearByPlacesUrl = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' +
            latitude.toString() +
            ',' +
            longitude.toString() +
            '&radius=' +
            ApiUrls.radius +
            '&key=' +
            ApiUrls.apiKey +
            '&types=' +
            ApiUrls.types +
            '&keyword=' +
            ApiUrls.keyword);

    print("Check URL:: " + nearByPlacesUrl.toString());

    // var response = await http.post(nearByPlacesUrl);
    // nearbyPlacesResponse =
    //     NearbyPlacesResponse.fromJson(jsonDecode(response.body));
    // print(nearbyPlacesResponse.results!.length);
    // setState(() {});

    var client = http.Client();

    try {
      var response = await client.get(nearByPlacesUrl);
      if (response.statusCode == 200) {
        //print("response.body  ::  ${response.body}");
        nearByPlacesResponse2 =
            NearbyPlacesResponse.fromJson(json.decode(response.body));
        print(
            "nearByPlacesResponse2  ::  ${nearByPlacesResponse2?.results![0].name}");
        return nearByPlacesResponse2;
      }
    } catch (Exception) {
      return nearByPlacesResponse2;
    }

    return nearByPlacesResponse2;
  }

  setRestaurantInList(BuildContext context) {
    return Expanded(
      child: nearByPlacesResponse2!.results!.isEmpty
          ? Text("No Data Found")
          : ListView.builder(
              itemCount: nearByPlacesResponse2!.results!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Set<String> savedWords = Set<String>();
                String word = nearByPlacesResponse2!.results![index].name!;
                bool isSaved = savedWords.contains(word);

                return Card(
                  color: Colors.white,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1),
                  ),
                  child: InkWell(
                      splashColor: Colors.grey,
                      onTap: (){
                        print(nearByPlacesResponse2!.results![index].name);
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                          return const NearByRestaurantOnMap();
                        }));
                      },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ListTile(
                          //   title: Text(
                          //     nearByPlacesResponse2!.results![index].name!,
                          //     style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                          //   ),
                          //   subtitle: Text(
                          //     nearByPlacesResponse2!.results![index].scope!,
                          //     style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                          //   ),
                          // ),
                          Row(
                            children: [
                              Container(
                                width: 80.0,
                                height: 80.0,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 0.5, color: Colors.blueGrey),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(nearByPlacesResponse2!
                                        .results![index].icon!),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        nearByPlacesResponse2!
                                            .results![index].name!,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                      const Text(
                                        'Rating',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.0),
                                      ),
                                      const Text(
                                        'Gives Star',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: const [
                                  CircleAvatar(
                                    backgroundColor: Colors.indigo,
                                    radius: 20,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundImage: AssetImage(
                                        'assets/icons/turn_right.png',
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  //Icon(Icons.favorite_outline_rounded)
                                  // IconButton(
                                  //   icon: Icon(
                                  //     isSaved
                                  //         ? Icons.favorite
                                  //         : Icons.favorite_outline_rounded,
                                  //     color: isSaved ? Colors.indigo : null,
                                  //   ),
                                  //   onPressed: () {
                                  //     setState(() {
                                  //       if (isSaved) {
                                  //         savedWords.remove(word);
                                  //       } else {
                                  //         savedWords.add(word);
                                  //       }
                                  //     });
                                  //   },
                                  // )
                                ],
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 12.0,
                          ),
                          Text(
                            nearByPlacesResponse2!.results![index].vicinity!,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14.0,
                                color: Colors.black54),
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          // Text(results.openingHours != null ? "Open" : "Closed"),
                          Text(
                            nearByPlacesResponse2!
                                        .results![index].openingHours !=
                                    null
                                ? 'Open Now'
                                : 'Closed',
                            style: TextStyle(
                                color: Colors.blue.shade500, fontSize: 16),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
