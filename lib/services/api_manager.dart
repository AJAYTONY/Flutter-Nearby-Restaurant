import 'dart:convert';
import 'package:flutter_nearby_restaurants/models/NearByRestaurantResponse.dart';
import 'package:flutter_nearby_restaurants/utils/constant.dart';
import 'package:http/http.dart' as http;

class APIManager {
  // Future<NearbyPlacesResponse> getNearbyPlacesResponseData(String latitude, String longitude) async {
  //   final uri = Uri.parse('$ApiUrls.baseURL/v1/endpoint').replace(queryParameters: {
  //     'page': page,
  //     'itemsPerPage': itemsPerPage,
  //   });
  //
  //   var client = http.Client();
  //   var nearbyPlacesResponse;
  //
  //   try{
  //     var response = await client.get(uri);
  //     if(response.statusCode == 200){
  //       var jsonResponse = response.body;
  //       var jsonMap = json.decode(jsonResponse);
  //
  //       nearbyPlacesResponse = NearbyPlacesResponse.fromJson(jsonMap);
  //     }
  //   }on Exception{
  //     return nearbyPlacesResponse;
  //   }
  //
  //   return nearbyPlacesResponse;
  //
  // }

}
