

import 'dart:async';

import 'package:afroevent/pages/TableView/basketTableView/basketGameStory.dart';
import 'package:afroevent/pages/TableView/basketTableView/basketEvenement.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/authController.dart';
import '../../models/event_models.dart';
import '../share/EventWidgetView.dart';
import '../share/messageView.dart';

class BasketballPage extends StatefulWidget {
  @override
  _BasketballPageState createState() => _BasketballPageState();
}

class _BasketballPageState extends State<BasketballPage> {
  AuthController authController=Get.find();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async {

      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,

            title: TabBar(
              tabs: [
                Tab(text: 'Événements'),
                Tab(text: 'Game Story'),
              ],
            ),
          ),
          body: TabBarView(
            children: [

              Center(child: BasketEvenementPage()), // Page pour le basket-ball
              Center(child:BasketGameStoryPage()
              ), // Page pour le basket-ball
            ],
          ),
        ),
      ),
    );
  }
}

