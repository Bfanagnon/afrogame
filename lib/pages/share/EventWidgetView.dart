import 'package:afroevent/controllers/authController.dart';
import 'package:afroevent/pages/details/eventDetail.dart';
import 'package:afroevent/pages/share/DateWidget.dart';
import 'package:afroevent/pages/share/navPage.dart';
import 'package:afroevent/pages/share/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/event_models.dart';
import '../auth/login.dart';
import 'FonctionWidget.dart';
import 'messageRequireWidget.dart';

class EventCard extends StatefulWidget {
  final EventData event;
  final UserData user;

  const EventCard({Key? key, required this.event, required this.user}) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  AuthController authController=Get.find();
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image du titre avec coins arrondis
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                UserProfileWidget(user: widget.event.user!,avatarSize: 20,iconSize: 12,textSize: 12,),

                GestureDetector(
                        onTap: () async {
                          if(authController.userLogged.id!=null){
                            if(!isIdInList(widget.user.id!,widget.event.usersVues==null?[]:widget.event.usersVues!)){
                              if(widget.event.usersVues!=null){
                                widget.event.usersVues!.add(widget.user.id!);

                              }

                            }
                            widget.event.vue=widget.event.vue!+1;
                            await authController.updateEvent(widget.event).then((value) {
                              setState(() {

                              });
                            },);

                            goToPage(context, DetailsEventPage(event: widget.event!));
                          }else{
                            showLoginRequiredDialog(context, () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleLoginScreen(),));

                            },);
                          }

                  },
                  child: Column(
                    children: [
                      Text(
                        widget.event.titre!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Image du poste
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.event.urlMedia!,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Description
                      Text(
                        widget.event.description!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Date et icônes
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Date
                          DateWidget(dateInMicroseconds: widget.event.date!),
                          Row(
                            children: [
                              // Icône vues
                              Row(
                                children: [
                                  const Icon(Icons.visibility, size: 16),
                                  const SizedBox(width: 4),
                                  Text(widget.event.vue.toString()),
                                ],
                              ),
                              const SizedBox(width: 16),
                              // Icône likes
                              GestureDetector(
                                onTap: () async {

                                  if(authController.userLogged.id!=null){
                                    if(!isIdInList(widget.user.id!,widget.event.userslikes== null?[]:widget.event.userslikes!)){
                                      if(widget.event.userslikes!=null){
                                        widget.event.userslikes!.add(widget.user.id!);

                                      }
                                      widget.event.like=widget.event.like!+1;
                                      await authController.updateEvent(widget.event);
                                      setState(() {

                                      });
                                    }

                                  }else{
                                    showLoginRequiredDialog(context, () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SimpleLoginScreen(),));

                                    },);
                                  }

                                },
                                child: Row(
                                  children: [
                                     Icon(Icons.thumb_up, size: 16,color:isIdInList(widget.user.id!,widget.event.userslikes==null?[]:widget.event.userslikes!!)? Colors.green:Colors.black,),
                                    const SizedBox(width: 4),
                                    Text(widget.event.like.toString()),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Icône commentaires
                              Row(
                                children: [
                                  const Icon(Icons.comment, size: 16),
                                  const SizedBox(width: 4),
                                  Text(widget.event.commentaire.toString()),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}