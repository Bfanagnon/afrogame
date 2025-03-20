

import 'package:flutter/material.dart';

class FootballPage extends StatefulWidget {
  @override
  _FootballPageState createState() => _FootballPageState();
}

class _FootballPageState extends State<FootballPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: 'Gbovian'),
              Tab(text: 'Match'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Container(child: Text("Gbovian"),)), // Page pour le basket-ball
            Center(child: Container(child: Text("Match"),)), // Page pour le basket-ball
          ],
        ),
      ),
    );
  }
}

