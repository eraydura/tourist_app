import 'package:image/image.dart' as IMG;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:tourist_app/modal/route_info.dart';
import 'package:tourist_app/view/map/guide.dart';

class RouteInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Locations(),
    );
  }
}



class Locations extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new StreamBuilder(
          stream: Firestore.instance.collection('landmark').where("route", isEqualTo: route_name).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            }
            else {
              return snapshot.hasData
                  ? Route(landmark: snapshot.data)
                  : Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
  }
}



class Route extends StatefulWidget {
  QuerySnapshot landmark;
  Route({this.landmark});
  @override
  _Route createState() => _Route(this.landmark);
}

class _Route extends State<Route> {
  GoogleMapController _controller;

  List<Marker> allMarkers = [];
  var dataBytes;
  PageController _pageController;
  int prevPage;
  QuerySnapshot landmark;
  _Route(this.landmark);

  @override
  void initState() {
    super.initState();

    for(var i=0; i<landmark.documents.length; i++) {
      GeoPoint geoPoint = landmark.documents[i]["location"];
      double lat = geoPoint.latitude;
      double lng = geoPoint.longitude;
      LatLng latLng = new LatLng(lat, lng);
      routes.add(
          new Routes(
            name: landmark.documents[i]["name"],
            description: landmark.documents[i]["description"],
            thumbNail: landmark.documents[i]["picture"],
            locationCoords: latLng,
            point: landmark.documents[i]["points"],
          )
      );

    }

    var rmarker;
    BitmapDescriptor.fromAssetImage(ImageConfiguration(), 'assets/start.png').then((value) => rmarker = value);

    routes.forEach((element) async {
        var iconurl = element.thumbNail;
        var request = await http.get(iconurl);
        var bytes = request.bodyBytes;
        IMG.Image img = IMG.decodeImage(bytes);
        IMG.Image resized = IMG.copyResize(img, width: 175, height: 175);
        var resizedData = IMG.encodeJpg(resized);

        setState(() {
          dataBytes = resizedData;
        });

      allMarkers.add(
            Marker(
                markerId: MarkerId(element.name),
                draggable: false,
                icon: element.name == "MyPosition" ? rmarker : BitmapDescriptor.fromBytes(dataBytes.buffer.asUint8List()),
                infoWindow: InfoWindow(title: element.name),
                position: element.locationCoords
              )
        );
    });

    _pageController = PageController(initialPage: 1, viewportFraction: 0.8)
      ..addListener(_onScroll);
  }



  void _onScroll() {
    if (_pageController.page.toInt() != prevPage) {
      prevPage = _pageController.page.toInt();
      moveCamera();
    }
  }

  _coffeeShopList(index) {
    return Visibility(
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      visible: index==0 ? false : true,
      child: AnimatedBuilder(
      animation: _pageController,
      builder: (BuildContext context, Widget widget) {
        double value = 1;
        if (_pageController.position.haveDimensions) {
          value = _pageController.page - index;
          value = (1 - (value.abs() * 0.3) + 0.06).clamp(0.0, 1.0);
        }
        return Center(
          child: SizedBox(
            height: Curves.easeInOut.transform(value) * 185.0,
            width: Curves.easeInOut.transform(value) * 400.0,
            child: widget,
          ),
        );
      },
      child: InkWell(
          onTap: () {
            // moveCamera();
          },
          child: Stack(children: [
            Center(
                child: Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 20.0,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black54,
                            offset: Offset(0.0, 4.0),
                            blurRadius: 10.0,
                          ),
                        ]),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Row(children: [
                          Container(
                              height: 150.0,
                              width: 100.0,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10.0),
                                      topLeft: Radius.circular(10.0)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          routes[index].thumbNail),
                                      fit: BoxFit.cover))),
                          SizedBox(width: 10.0),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  routes[index].name,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                    width: 170.0,
                                    child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children:[
                                          Text(
                                            routes[index].description,
                                            style: TextStyle(
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w300),
                                          ),
                                          SizedBox(height: 10,),

                                        ]
                                    ))
                              ])
                        ]))))
          ])),
    )
    );
  }


  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: height,
              width: width,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                    target: currentPostion, zoom: 12.0),
                markers: Set.from(allMarkers),
                onMapCreated: mapCreated,
                myLocationEnabled: true,
              ),
            ),
            Positioned(
              top: 65.0,
              right: 25,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Icon(Icons.navigation),
                backgroundColor: Colors.black,
              ),
            ),
            Positioned(
              top: 65.0,
              right: width-75.0,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pop(context);
                },
                child: Icon(Icons.assignment_return),
                backgroundColor: Colors.black,
              ),
            ),
            Positioned(
              bottom: 20.0,
              child: Container(
                height: 200.0,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: routes.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _coffeeShopList(index);
                  },
                ),
              ),
            )
          ],
        ),
    );

  }

  void mapCreated(controller) {
    setState(() async {
      _controller = controller;
      String value = await DefaultAssetBundle.of(context).loadString("assets/google_maps.json");
      controller.setMapStyle(value);
    });
  }

  moveCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: routes[_pageController.page.toInt()].locationCoords,
        zoom: 14.0,
        bearing: 45.0,
        tilt: 45.0)));
  }

}

