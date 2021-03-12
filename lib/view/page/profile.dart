import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tourist_app/modal/route_info.dart';

import '../authenticate_page.dart';

class Profile extends StatefulWidget {
  @override
  _MyProfilePage createState() => _MyProfilePage();
}

class _MyProfilePage extends State<Profile> {
  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  TextEditingController image = new TextEditingController();
  FocusNode myFocusNode = FocusNode();
  var _index=0;
  var index=0;
  var index_2=0;
  var index_3=0;
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
                            child: Column(
                              children: [
                                Text("Total Points: "+ points.toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                                RaisedButton(onPressed:(){ Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthenticatePage()), (Route<dynamic> route) => false);}, color: Colors.red,child: Text("Log out",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),),
                              ],
                            )
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

                  Text("Your Feed"),

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
                new StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("Feed").where("user_name", isEqualTo: username).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                      else {
                        return snapshot.hasData
                            ?  SizedBox(
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.width-15,// card height
                          child: PageView.builder(
                            itemCount: snapshot.data.documents.length,
                            controller: PageController(viewportFraction: 0.75),
                            onPageChanged: (int index) => setState(() => index = index),
                            itemBuilder: (_, i) {
                              return Transform.scale(
                                scale: i == index ? 1 : 0.9,
                                child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: ListTile(
                                    subtitle: SizedBox(
                                                      child:Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text( snapshot.data.documents[i]['title'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                                          SizedBox(height: 10,),
                                                          Text(snapshot.data.documents[i]['description'],style: TextStyle(fontSize: 15),),
                                                          SizedBox(height: 25,),
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      new Text( snapshot.data.documents[i]['time'].toDate().day.toString()+"-"+snapshot.data.documents[i]['time'].toDate().month.toString()+"-"+snapshot.data.documents[i]['time'].toDate().year.toString(), style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),),
                                                                      new Text( snapshot.data.documents[i]['time'].toDate().hour.toString()+":"+snapshot.data.documents[i]['time'].toDate().minute.toString(), style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
                                                                    ],),
                                                                ],
                                                              ),
                                                              InkWell(
                                                                onTap: (){
                                                                  if(snapshot.data.documents[i]["interested"].length>0) {
                                                                    showBarModalBottomSheet(
                                                                        expand: true,
                                                                        context: context,
                                                                        backgroundColor: Colors
                                                                            .transparent,
                                                                        builder: (
                                                                            context) =>
                                                                        new ListView.builder(
                                                                          itemCount: snapshot.data.documents[i]["interested"].length,
                                                                          itemBuilder: (context, index) {
                                                                            final item = snapshot.data.documents[i]["interested"][index];

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
                                                                },
                                                                child:
                                                                Padding(
                                                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                                    child: Row(
                                                                      children: [
                                                                        Icon(Icons.thumb_up,size: 25),
                                                                        SizedBox(width: 5,),
                                                                        Text(snapshot.data.documents[i]["interested"].length.toString()),
                                                                      ],)
                                                                ),
                                                              ),
                                                              snapshot.data.documents[i]["image"]!="" ?
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
                                                                          new Text("Saved Image from " +snapshot.data.documents[i]["user_name"],style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
                                                                          new Image.network(snapshot.data.documents[i]["image"],width: 500,height: 500,),
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
                                                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                  child: Icon(Icons.image,size: 25,),
                                                                ),
                                                              ): Container(),

                                                              InkWell(
                                                                onTap: () {
                                                                  //TODO: Firestore delete a record code
                                                                  Firestore.instance
                                                                      .collection("Feed")
                                                                      .document(snapshot.data.documents[i].documentID)
                                                                      .delete()
                                                                      .catchError((e) {
                                                                    print(e);
                                                                  });
                                                                },
                                                                child:
                                                                Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                      horizontal: 20, vertical: 10),
                                                                  child: Icon(Icons.delete),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                              ],)),
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

                  Text("You Liked"),

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
                new StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("Feed").where("interested", arrayContains: username).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }
                      else {
                        return snapshot.hasData
                            ?  SizedBox(
                          height: MediaQuery.of(context).size.height/4,
                          width: MediaQuery.of(context).size.width-15,// card height
                          child: PageView.builder(
                            itemCount: snapshot.data.documents.length,
                            controller: PageController(viewportFraction: 0.75),
                            onPageChanged: (int index) => setState(() => _index = index),
                            itemBuilder: (_, i) {
                              return Transform.scale(
                                scale: i == _index ? 1 : 0.9,
                                child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  child: ListTile(
                                    subtitle: Row(
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
                                                NetworkImage(snapshot.data.documents[i]['user_image']),
                                                backgroundColor: Colors.transparent,
                                              ),
                                              SizedBox(height: 5,),
                                              Text(snapshot.data.documents[i]["user_name"],style: TextStyle(color: Colors.white70,),),
                                              SizedBox(height: 5,),
                                              Column(
                                                children: [
                                                  new Text( snapshot.data.documents[i]['time'].toDate().day.toString()+"-"+snapshot.data.documents[i]['time'].toDate().month.toString()+"-"+snapshot.data.documents[i]['time'].toDate().year.toString(), style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
                                                  new Text( snapshot.data.documents[i]['time'].toDate().hour.toString()+":"+snapshot.data.documents[i]['time'].toDate().minute.toString(), style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
                                                ],),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 150,
                                          height: 140,
                                          child:Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(snapshot.data.documents[i]['title'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                              Text(snapshot.data.documents[i]['description'],style: TextStyle(fontSize: 15),),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: (){
                                                      List a=snapshot.data.documents[i]["interested"];
                                                      a.add(username);
                                                      Firestore.instance.collection("Feed").document(snapshot.data.documents[i].documentID).updateData({"interested": FieldValue.arrayUnion(a)});;
                                                    },
                                                    child:
                                                    Padding(
                                                        padding: EdgeInsets.symmetric( vertical: 10),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.thumb_up,size: 20,),
                                                            SizedBox(width: 5,),
                                                            Text(snapshot.data.documents[i]["interested"].length.toString()),
                                                          ],)
                                                    ),
                                                  ),
                                                  snapshot.data.documents[i]["image"]!="" ?
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
                                                              new Text("Saved Image from " +snapshot.data.documents[i]["user_name"],style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),),
                                                              new Image.network(snapshot.data.documents[i]["image"],width: 500,height: 500,),
                                                              FlatButton(
                                                                child: Text('Close me!'),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                              ),
                                                            ],
                                                          ));
                                                    },
                                                    child: Icon(Icons.image,size: 20,),
                                                  ): Container(),
                                                ],
                                              )

                                            ],),
                                        ),],)

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

                  Text("Your Route & Liked"),

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

                  Text("Your Caffees & Liked"),

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
              ],),
          )),
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
                          Map<String, dynamic> newBook = new Map<String,dynamic>();
                          newBook["title"] = title.text;
                          newBook["description"] = description.text;
                          newBook["image"] = image.text;
                          newBook["interested"] = [];
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
                        child: Text("Change", style: TextStyle(color: Colors.white),),
                      ),
                    ])
              ],
            ),
          );},
        child: Icon(Icons.add,color: Colors.white70,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}


