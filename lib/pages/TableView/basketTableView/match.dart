

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/authController.dart';
import '../../../models/event_models.dart';
import '../../share/EventWidgetView.dart';
import '../../share/messageView.dart';


class BasketMatchPage extends StatefulWidget {
  @override
  _BasketMatchPageState createState() => _BasketMatchPageState();
}

class _BasketMatchPageState extends State<BasketMatchPage> {
  AuthController authController=Get.find();
  StreamController<List<EventData>> _streamController = StreamController<List<EventData>>();

  bool isLoading=false;
  List<EventData> listConstposts=[];
  @override
  void initState() {
    // TODO: implement initState
    authController.getEventDatasImages(40).listen((data) {
      _streamController.add(data);
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _streamController.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: ()async {

        await authController.getEventDatasImages(40).listen((data) {
          _streamController.add(data);
        });
      },
      child:               Center(child:StreamBuilder<List<EventData>>(
        // stream: authController.getEventDatasImages(40,),
        stream: _streamController.stream,

        // initialData: postProvider.listConstposts,
        builder: (context, snapshot) {
          printVm('Error snapshot: ${snapshot.data}');

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            printVm('Error: ${snapshot.error}');
            return Center(child: Icon(Icons.error));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No posts found'));
          }
          // Mettre à jour seulement si de nouvelles données arrivent
          if (!isLoading && snapshot.data != listConstposts) {

            listConstposts = snapshot.data!;

          }

          listConstposts = snapshot.data!;

          return ListView.builder(
            itemCount: listConstposts.length,
            itemBuilder: (context, index) {
              var event=listConstposts[index];
              // if(event.typeJeu==TypeJeu.Gbovian.name){
              //   return EventCard(event: event);
              //
              // }

              if(event.typeJeu==TypeJeu.Match.name) {
                return EventCard(event: event, user: authController.userLogged,);
              } else {
                return const SizedBox.shrink();
              }
            },);
        },
      ),
      ),
    );
  }
}

