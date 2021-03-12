import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng currentPostion;

class Routes {
  String name;
  String description;
  String thumbNail;
  int point;
  LatLng locationCoords;

  Routes(
      {this.name,
        this.description,
        this.thumbNail,
        this.point,
        this.locationCoords});
}


List<Routes> routes = [
  new Routes(
    name: "MyPosition",
    description: "You are now here",
    thumbNail: "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png",
    locationCoords: currentPostion,
    point: 0,
  )
];

var how_to_go;
var language;
var route_name;
var city;
var points= 0;
var gained_point=0;
var username="erayd";
var user_image="https://www.w3schools.com/howto/img_avatar.png";
