import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tourist_app/modal/route_info.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController image = new TextEditingController();
  var documents="landmark";
  int segmentedControlGroupValue = 0;
  int _index = 0;
  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Landmark"),
    1: Text("Museum"),
    2: Text("Nature"),
    3: Text("Caffee")
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:  SingleChildScrollView(
        child: Column(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child:Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundImage:
                  NetworkImage(user_image),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(username.toUpperCase(),style: TextStyle(fontWeight: FontWeight.bold),),
                    Text(city.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                  ],),
                Container(
                  margin: EdgeInsets.only(left:MediaQuery.of(context).size.width-300),
                  child: Text("Total Points: "+ points.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                )
              ],),
          ),
          Row(children: <Widget>[
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: Divider(
                    color: Colors.white70,
                    height: 50,
                    thickness: 2,
                  )),
            ),

            Text("Points of Interest"),

            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                  child: Divider(
                    color: Colors.white70,
                    height: 50,
                    thickness: 2,
                  )),
            ),
          ]),
          SizedBox(height: 10,),
            Container(
              child: CupertinoSlidingSegmentedControl(
                  groupValue: segmentedControlGroupValue,
                  children: myTabs,
                  thumbColor: Colors.blueGrey,
                  onValueChanged: (i) {
                    setState(() {
                      segmentedControlGroupValue = i;
                      if(i==0){
                        setState(() {
                          documents="landmark";
                        });
                      }
                      else if(i==1){
                        setState(() {
                          documents="Museum";
                        });
                      }
                      else if(i==2){
                        setState(() {
                          documents="Nature";
                        });
                      }
                      else{
                        setState(() {
                          documents="Caffee";
                        });
                      }
                    });
                  }),
            ),
          SizedBox(height: 10,),
          new StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection(documents).where("city", isEqualTo: city.toString().toLowerCase()).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                }
                else {
                  return snapshot.hasData
                      ?  SizedBox(
                      height: MediaQuery.of(context).size.height/3,
                      width: MediaQuery.of(context).size.width-10,// card height
                      child: PageView.builder(
                        itemCount: snapshot.data.documents.length,
                        controller: PageController(viewportFraction: 0.85),
                        onPageChanged: (int index) => setState(() => _index = index),
                        itemBuilder: (_, i) {
                          return Transform.scale(
                              scale: i == _index ? 1 : 0.9,
                              child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: ListTile(
                                    subtitle: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          height: 150,
                                          child: CachedNetworkImage(
                                            imageUrl:  snapshot.data.documents[i]["picture"],
                                            fit: BoxFit.fill,
                                          ),
                                        ),

                                      SizedBox(
                                        width: 170,
                                      child:Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                        Text( snapshot.data.documents[i]['name'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                        Text(snapshot.data.documents[i]['description'],style: TextStyle(fontSize: 15),),
                                      ],)
                                      ),
                                    ],),
                                  ),
                                ),
                              );
                         },
                      ),
                    )
                      : Center(child: CircularProgressIndicator());
                }
              }
          ),
          SizedBox(height: 10,),
          Row(children: <Widget>[
            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  child: Divider(
                    color: Colors.white70,
                    height: 50,
                    thickness: 2,
                  )),
            ),

            Text("All Feeds"),

            Expanded(
              child: new Container(
                  margin: const EdgeInsets.only(left: 15.0, right: 10.0),
                  child: Divider(
                    color: Colors.white70,
                    height: 50,
                    thickness: 2,
                  )),
            ),
          ]),
        StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('Feed').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(child: CircularProgressIndicator(),);
            default:
              return new ListView(
                padding: EdgeInsets.only(top: 10),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
                    child: Card(
                      child: ListTile(
                        onTap: (){
                          if(document["user_name"]==username) {
                            showBarModalBottomSheet(
                              expand: true,
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(left: 20,right:20),
                                        child:TextField(
                                          controller: title,
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            hintText: document['title'],
                                            filled: true,
                                            fillColor: Color(0xFFDBEDFF),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              borderSide: BorderSide(color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              borderSide: BorderSide(color: Colors.grey),
                                            ),
                                          ),
                                        ),),

                                      Padding(
                                        padding: EdgeInsets.only(left: 20,right:20),
                                        child:TextField(
                                          minLines: 1,
                                          maxLength: 140,
                                          controller: description,
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            hintText: document['description'],
                                            filled: true,
                                            fillColor: Color(0xFFDBEDFF),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              borderSide: BorderSide(color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              borderSide: BorderSide(color: Colors.grey),
                                            ),
                                          ),
                                        ),),
                                      document['image']!="" ?
                                      Padding(
                                        padding: EdgeInsets.only(left: 20,right:20),
                                        child:TextField(
                                          controller: image,
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            hintText: document['image'],
                                            filled: true,
                                            fillColor: Color(0xFFDBEDFF),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              borderSide: BorderSide(color: Colors.grey),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                              borderSide: BorderSide(color: Colors.grey),
                                            ),
                                          ),
                                        ),): new Container(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: RaisedButton(
                                          color: Colors.red,
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Undo", style: TextStyle(
                                              color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      // Update Button
                                      RaisedButton(
                                          child: Text("update",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () {
                                            Map<String,
                                                dynamic> updateBook = new Map<
                                                String,
                                                dynamic>();
                                            updateBook["title"] = title.text;
                                            updateBook["description"] =
                                                description.text;
                                            updateBook["image"] = image.text;

                                            // Updae Firestore record information regular way
                                            Firestore.instance
                                                .collection("Feed")
                                                .document(document.documentID)
                                                .updateData(updateBook)
                                                .whenComplete(() {
                                              Navigator.of(context).pop();
                                            });
                                          }
                                      ),
                                    ],
                                  ),
                            );
                          }
                        },
                       subtitle : Row(
                         children: [
                          SizedBox(
                          width: 80,
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 25.0,
                                backgroundImage:
                                NetworkImage(document['user_image']),
                                backgroundColor: Colors.transparent,
                              ),
                              SizedBox(height:5),
                              Text(document["user_name"],style: TextStyle(color: Colors.white70),),
                              SizedBox(height:5),
                              Column(
                                children: [
                                  new Text( document['time'].toDate().day.toString()+"-"+document['time'].toDate().month.toString()+"-"+document['time'].toDate().year.toString(), style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
                                  new Text( document['time'].toDate().hour.toString()+":"+document['time'].toDate().minute.toString(), style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
                                ],),
                            ],
                          ),
                        ),
                          SizedBox(
                            width: 240,
                            height: 140,
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text( document['title'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                              Text(document['description'],style: TextStyle(fontSize: 15),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      if(document["user_name"]!=username) {
                                        List a = document["interested"];
                                        a.add(username);
                                        Firestore.instance.collection(
                                            "Feed").document(document.documentID).updateData(
                                            {"interested": FieldValue
                                                .arrayUnion(a)});
                                      }
                                      else{
                                        if(document["interested"].length>0) {
                                          showBarModalBottomSheet(
                                            expand: true,
                                            context: context,
                                            backgroundColor: Colors
                                                .transparent,
                                            builder: (
                                                context) =>
                                            new ListView.builder(
                                              itemCount: document["interested"].length,
                                              itemBuilder: (context, index) {
                                                final item = document["interested"][index];

                                                return ListTile(
                                                  subtitle: Text(item,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold),),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    child:
                                    Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.thumb_up,size: 25,color: document["interested"].contains(username) ? Colors.red : Colors.teal),
                                            SizedBox(width: 5,),
                                            Text(document["interested"].length.toString()),
                                          ],)
                                    ),
                                  ),
                                  document["image"]!="" ?
                                  InkWell(
                                    onTap: (){
                                      showBarModalBottomSheet(
                                          expand: true,
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                          new Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              new Text("Saved Image from " +document["user_name"],style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
                                              new Image.network(document["image"],width: 500,height: 500,),
                                              FlatButton(
                                                child: Text('Close me!'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ));
                                    },
                                    child:
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: Icon(Icons.image,size: 25,),
                                    ),
                                  ): Container(),
                                  document["user_name"]==username ?
                                  InkWell(
                                    onTap: () {
                                      //TODO: Firestore delete a record code
                                      Firestore.instance
                                          .collection("Feed")
                                          .document(document.documentID)
                                          .delete()
                                          .catchError((e) {
                                        print(e);
                                      });
                                    },
                                    child:
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      child: Icon(Icons.delete),
                                    ),
                                  ) : Container(),
                                ],
                              )

                            ],),
                          ),],)
                      ),
                    ),
                  );
                }).toList(),
              );
          }
        },
      ),
        ],),
        )),
      // ADD (Create)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          showBarModalBottomSheet(
            expand: true,
            context: context,
            backgroundColor: Colors.transparent,
            builder: (context) => Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20,right:20),
                  child:TextField(
                    controller: title,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Write your title here',
                      filled: true,
                      fillColor: Color(0xFFDBEDFF),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),),

                Padding(
                  padding: EdgeInsets.only(left: 20,right:20),
                  child:TextField(
                    minLines: 1,
                    maxLength: 140,
                    controller: description,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Write your status here',
                      filled: true,
                      fillColor: Color(0xFFDBEDFF),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),),
                Padding(
                  padding: EdgeInsets.only(left: 20,right:20),
                  child:TextField(
                    controller: image,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: 'Write your image here',
                      filled: true,
                      fillColor: Color(0xFFDBEDFF),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:[
                RaisedButton(
                  color: Colors.red,
                  onPressed: () { Navigator.of(context).pop();},
                  child: Text("Undo", style: TextStyle(color: Colors.white),),),

                RaisedButton(

                  onPressed: () {
                    //TODO: Firestore create a new record code

                    Map<String, dynamic> newBook = new Map<String,dynamic>();
                    newBook["title"] = title.text;
                    newBook["description"] = description.text;
                    newBook["image"] = image.text;
                    newBook["interested"] = [];;
                    newBook["user_name"] = username;
                    newBook["user_image"] = user_image;
                    newBook["time"] =new DateTime.now();

                    Firestore.instance
                        .collection("Feed")
                        .add(newBook)
                        .whenComplete((){
                      Navigator.of(context).pop();
                    } );

                  },
                  child: Text("Save", style: TextStyle(color: Colors.white),),
                ),
              ])
            ],
            ),
          );},
        tooltip: 'Add Title',
        child: Icon(Icons.add,color: Colors.white70,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}


