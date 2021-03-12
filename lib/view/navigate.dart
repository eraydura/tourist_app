import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bottom_bars/bottom_bars.dart';
import 'package:tourist_app/view/page/home.dart';
import 'package:tourist_app/view/page/profile.dart';
import 'package:tourist_app/view/page/routes.dart';
import 'package:tourist_app/view/page/chat.dart';
import 'page/profile.dart';

class Navigate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TabsPage(),
    );
  }
}

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {

  @override
  Widget build(BuildContext context) {
    return BottomBars(
      type: 0,
      backgroundColor: Colors.blueGrey,
      tabs: <Widget>[
        Container(
          child: MyHomePage(),
        ),
        Container(
          child: Profile(),
        ),
        Container(
          child: Routes_Location(),
        ),
        Container(
          child: HomePage(),
        ),
      ],
      items: [
        BottomBarsItem(
            icon: Icon(Icons.home,color: Colors.white70,),
            title: Text("Home",style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
            color: Color.fromRGBO(25, 25, 25,1.0)),
        BottomBarsItem(
          icon: Icon(Icons.face,color: Colors.white70,),
          title: Text("Profile",style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
          color: Color.fromRGBO(25, 25, 25,1.0),
        ),
        BottomBarsItem(
            icon: Icon(Icons.directions_walk,color: Colors.white70,),
            title: Text("Routes",style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
            color: Color.fromRGBO(25, 25, 25,1.0)),
        BottomBarsItem(
            icon: Icon(Icons.chat,color: Colors.white70,),
            title: Text("Chat",style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),),
            color: Color.fromRGBO(25, 25, 25,1.0)),
      ],
    );
  }
}