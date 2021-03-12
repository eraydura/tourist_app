import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mapbox_navigation/library.dart';
import 'package:tourist_app/view/map/map.dart';
import '../../modal/route_info.dart';

class Routes_Location extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Landmark'),
                Tab(text: 'Nature',),
                Tab(text: 'Museum'),
              ],
            ),
            backgroundColor: Colors.blueGrey,
            toolbarHeight: 70,
            shadowColor: Colors.white70,
          ),
          body: TabBarView(
            children: [
                new StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('routes').where("city", isEqualTo: city.toString().toLowerCase()).where("type", isEqualTo: "Landmark").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    else {
                      return snapshot.hasData
                          ? Route_List(landmark: snapshot.data)
                          : Center(child: CircularProgressIndicator());
                    }
                  }
              ),
              new StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('routes').where("city", isEqualTo: city).where("type", isEqualTo: "Nature").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    else {
                      return snapshot.hasData
                          ? Route_List(landmark: snapshot.data)
                          : Center(child: CircularProgressIndicator());
                    }
                  }
              ),
              new StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('routes').where("city", isEqualTo: city).where("type", isEqualTo: "Museum").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                    if (snapshot.hasError) {
                      print(snapshot.error);
                    }
                    else {
                      return snapshot.hasData
                          ? Route_List(landmark: snapshot.data)
                          : Center(child: CircularProgressIndicator());
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}



class Route_List extends StatefulWidget {
  QuerySnapshot landmark;
  Route_List({this.landmark});
  @override
  _Route createState() => _Route(this.landmark);
}

class _Route extends State<Route_List> {
  QuerySnapshot landmark;
  _Route(this.landmark);

  @override
  void initState() {
    super.initState();

    if(gained_point!=0) {
      WidgetsBinding.instance.addPostFrameCallback(_showOpenDialog);
    }

  }

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: SizedBox(
          height: 450, // card height
          child: PageView.builder(
            itemCount: landmark.documents.length,
            controller: PageController(viewportFraction: 0.7),
            onPageChanged: (int index) => setState(() => _index = index),
            itemBuilder: (_, i) {
              return Transform.scale(
                scale: i == _index ? 1 : 0.9,
                child: InkWell(
                  onTap: () {
                    setState(() {

                      if(landmark.documents[i]["how"]=="Walking") {
                        how_to_go = MapBoxNavigationMode.walking;
                      }
                      else{
                        how_to_go = MapBoxNavigationMode.drivingWithTraffic;
                      }

                      route_name=landmark.documents[i]["name"];

                      Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) =>
                              RouteInfo()));
                    });
                  },
                  child:Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Column(
                      children: [
                    Container(
                    height: 270,
                    width: 300,
                      child: FittedBox(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.network(landmark.documents[i]["picture"]),
                        ),
                        fit: BoxFit.fill,
                      )
                    ),
                      SizedBox(height: 10),
                      Text(
                        landmark.documents[i]["name"],
                        style: TextStyle(fontSize: 20),
                      ),
                      Divider(
                        color: Colors.black26,
                        thickness: 1.0,
                      ),
                      SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.only(left: 100),
                      child:Row(
                        children: [
                          Icon(Icons.monetization_on,size: 25,),
                          SizedBox(width: 5,),
                          Text(landmark.documents[i]["total"].toString()),
                        ],)),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.only(left: 100),
                        child: Row(
                          children: [
                            Icon(Icons.directions_bus,size: 25,),
                            SizedBox(width: 5,),
                            Text(landmark.documents[i]["how"].toString()),
                          ],),
                      ),
                      SizedBox(height: 10,),
                    Padding(
                      padding: EdgeInsets.only(left: 100),
                      child:InkWell(
                        onTap: (){
                          List a=landmark.documents[i]["like"];
                          a.add(username);
                          Firestore.instance.collection("routes").document(landmark.documents[i].documentID).updateData({"like": FieldValue.arrayUnion(a)});;
                        },
                        child:
                        Row(
                              children: [
                                Icon(Icons.thumb_up),
                                SizedBox(width: 5,),
                                Text(landmark.documents[i]["like"].length.toString()),
                              ],)
                        )),

                    ],),

                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _showOpenDialog(_) {
    AwesomeDialog(
        context: context,
        animType: AnimType.LEFTSLIDE,
        dialogType: DialogType.SUCCES,
        headerAnimationLoop: true,
        btnOkText: "Continue",
        autoHide: Duration(seconds: 5),
        body: Center(
          child: Column(children: [
            Text(
              "Success!",
              style: TextStyle(fontSize:20.0,fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15,),
            Text(
              'Your gained points: ' +gained_point.toString(),
              style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),
            Text(
              'Your total points: ' +points.toString(),
              style: TextStyle(fontStyle: FontStyle.italic,fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),
          ],)
        ),
        )..show();
  }

}

