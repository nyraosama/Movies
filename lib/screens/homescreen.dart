import 'package:flutter/material.dart';
import 'package:movie_swira/screens/FavouriteScreen.dart';
import 'package:movie_swira/utils/theme.dart' as Style;
 import 'package:movie_swira/widgets/now_playing.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Style.Colors.mainColor,
      appBar: AppBar(
        backgroundColor: Style.Colors.mainColor,
        centerTitle: true,
        title: Text(
          " Swira Movies",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Row(
            children: [
  
              TextButton(child: Text("My Favorites"),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavouriteScreen(),));


              },),

            ],
          ),
        ],
      ),
      body:  NowPlaying(),
    );
  }
}
