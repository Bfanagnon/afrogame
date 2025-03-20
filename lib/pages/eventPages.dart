
import 'package:afroevent/pages/share/ButtonWidget.dart';
import 'package:flutter/material.dart';

import 'TableView/basketPage.dart';
import 'TableView/football.dart';
import 'TableView/otherEvent.dart';

class EventPage extends StatefulWidget {
  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: 'Basket-ball'),
              Tab(text: 'Football'),
              Tab(text: 'Autres Événements'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BasketballPage(), // Page pour le basket-ball
            FootballPage(), // Page pour le football
            OtherEventsPage(), // Page pour les autres événements
          ],
        ),
      ),
    );
  }
}