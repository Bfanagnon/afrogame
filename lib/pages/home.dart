
import 'package:afroevent/pages/accueil.dart';
import 'package:afroevent/pages/eventPages.dart';
import 'package:afroevent/pages/share/ButtonWidget.dart';
import 'package:afroevent/pages/share/LogoText.dart';
import 'package:afroevent/pages/share/messageRequireWidget.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

import '../controllers/authController.dart';
import 'TableView/basketPage.dart';
import 'TableView/football.dart';
import 'TableView/otherEvent.dart';
import 'auth/login.dart';
import 'new/newEvent.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final autoSizeGroup = AutoSizeGroup();
  var _bottomNavIndex = 0; //default index of a first screen
  AuthController authController=Get.find();

  late AnimationController _fabAnimationController;
  late AnimationController _borderRadiusAnimationController;
  late Animation<double> fabAnimation;
  late Animation<double> borderRadiusAnimation;
  late CurvedAnimation fabCurve;
  late CurvedAnimation borderRadiusCurve;
  late AnimationController _hideBottomBarAnimationController;
  // Liste des widgets correspondant à chaque page
  final List<Widget> pages = [
    Center(child: AccueilPage()),
    Center(child: BasketballPage()),
    Center(child: FootballPage()),
    Center(child: EventPage()),
  ];
  final iconList = <IconData>[
    Entypo.home,
    Ionicons.basketball,
    Ionicons.football,
    MaterialIcons.event,

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: LogoText(),
        actions: [
          IconButton(onPressed: () {
setState(() {

});
          }, icon: Icon(Icons.notifications_active,color: Colors.green,))
        ],
      ),
      body: IndexedStack(
        index: _bottomNavIndex, // Affiche la page correspondant à l'index actuel
        children: pages,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          if(authController.userLogged.id!=null){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NewEventPage(),));

          }else{

            showLoginRequiredDialog(context, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleLoginScreen(),));

            },);

          }

        },
        child: Icon(color: Colors.white,Ionicons.ios_add_circle),
        //params
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        iconSize: 35,
        activeColor: Colors.green,
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.verySmoothEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) {
    setState(() {
      _bottomNavIndex = index;
    });          },
        //other params
      ),
    );
  }
}