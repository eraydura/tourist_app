import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:tourist_app/modal/route_info.dart';
import 'package:tourist_app/view/page/routes.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _instruction = "";
  MapBoxNavigation _directions;
  MapBoxOptions _options;
  bool _arrived = false;
  bool _isMultipleStop = false;
  double _distanceRemaining, _durationRemaining;
  MapBoxNavigationViewController _controller;
  bool _routeBuilt = false;
  bool _isNavigating = false;
  var i=1;

  @override
  void initState() {
    super.initState();
    initialize();
    _isMultipleStop = true;
    var wayPoints = List<WayPoint>();
    for(var i=0; i<3; i++){
      wayPoints.add(
          WayPoint(
          name: routes[i].name,
          latitude: routes[i].locationCoords.latitude,
          longitude: routes[i].locationCoords.longitude)
      );
    }

    _directions.startNavigation(
        wayPoints: wayPoints,
        options: MapBoxOptions(
            mode: how_to_go,
            simulateRoute: true,
            language: language,
            alternatives: true,
            units: VoiceUnits.metric)
    );
  }

  Future<void> initialize() async {
    if (!mounted) return;
    _directions = MapBoxNavigation(onRouteEvent: _onEmbeddedRouteEvent);
  }

  @override
  Widget build(BuildContext context) {
    returned();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
      ),
    );
  }

  Future<void> _onEmbeddedRouteEvent(e) async {
    _distanceRemaining = await _directions.distanceRemaining;
    _durationRemaining = await _directions.durationRemaining;

    switch (e.eventType) {
      case MapBoxEvent.progress_change:
        var progressEvent = e.data as RouteProgressEvent;
        _arrived = progressEvent.arrived;
        if (progressEvent.currentStepInstruction != null)
          _instruction = progressEvent.currentStepInstruction;
        break;
      case MapBoxEvent.route_building:
      case MapBoxEvent.route_built:
        setState(() {
          _routeBuilt = true;
        });
        break;
      case MapBoxEvent.route_build_failed:
        setState(() {
          _routeBuilt = false;
        });
        break;
      case MapBoxEvent.navigation_running:
        setState(() {
          _isNavigating = true;
        });
        break;
      case MapBoxEvent.on_arrival:
        await Future.delayed(Duration(seconds: 5));
        setState(() {
          _arrived = true;
          points+= routes[i].point;
          gained_point=points;
          i+=1;
        });
        break;
      case MapBoxEvent.navigation_finished:
      case MapBoxEvent.navigation_cancelled:
        setState(() {
          _routeBuilt = false;
          _isNavigating = false;
        });
        break;
      default:
        break;
    }
    setState(() {});
  }

  void returned() {
    if(this._isNavigating==false){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Routes_Location()),
      );
    }
  }

}


