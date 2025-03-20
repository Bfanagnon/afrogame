import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/authController.dart';
import '../../../models/event_models.dart';
import '../../details/eventDetail.dart';
import '../../share/DateWidget.dart';
import '../../share/EventWidgetView.dart';
import '../../share/messageView.dart';

class BasketGameStoryPage extends StatefulWidget {
  @override
  _BasketGameStoryPageState createState() => _BasketGameStoryPageState();
}

class _BasketGameStoryPageState extends State<BasketGameStoryPage> {
  final AuthController authController = Get.find();
  final StreamController<List<EventData>> _streamController = StreamController<List<EventData>>();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    authController.getEventDatasImages(40).listen((data) {
      _streamController.add(data);
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder<List<EventData>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement'));
          }
          final events = snapshot.data ?? [];
          final gbovianEvents = events.where((e) => e.typeJeu == TypeJeu.Gbovian.name).toList();

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text('Game Story'),
                floating: true,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final event = gbovianEvents[index];
                    return _buildEventCard(event, size);
                  },
                  childCount: gbovianEvents.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEventCard(EventData event, Size size) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section média (image/vidéo)
          _buildMediaSection(event, size),

          // Contenu de l'événement
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.titre!, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16),
                    SizedBox(width: 4),
                    DateWidget(dateInMicroseconds: event.date!),
                    Spacer(),
                    Icon(Icons.people_alt, size: 16),
                    SizedBox(width: 4),
                    Text('${0}'),
                  ],
                ),
              ],
            ),
          ),

          // Barre d'actions
          _buildActionBar(event),
        ],
      ),
    );
  }

  Widget _buildMediaSection(EventData event, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsEventPage(event: event),
          ),
        );
      },
      child: Container(
          height: size.height * 0.25,
          width: double.infinity,
          decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(4))),
      child: event.medias.isNotEmpty
      ? CachedNetworkImage(
      imageUrl: event.medias.first['url']!,
      fit: BoxFit.cover,
      )
          : Placeholder(),
      ),
    );
    }

  Widget _buildActionBar(EventData event) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.favorite ,
            count: event.like!,
            // color:  Colors.red ,
            onPressed: () => _toggleLike(event),
          ),
          _buildActionButton(
            icon: Icons.comment,
            count: 0,
            onPressed: () => _showComments(event),
          ),
          _buildActionButton(
            icon: Icons.visibility,
            count: event.vue!,
            onPressed: () {},
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _shareEvent(event),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required int count,
    Color? color,
    required Function() onPressed,
  }) {
    return TextButton.icon(
      icon: Icon(icon, color: color ?? Colors.grey[600]),
      label: Text('$count', style: TextStyle(color: Colors.grey[600])),
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  void _toggleLike(EventData event) {
    // authController.toggleEventLike(event.id!);
    // setState(() {
    //   event.isLiked = !event.isLiked;
    //   event.like += event.isLiked ? 1 : -1;
    // });
  }

  void _showComments(EventData event) {
    // Get.to(() => CommentsPage(eventId: event.id!));
  }

  void _shareEvent(EventData event) {
    // Implémentez la logique de partage
    // final text = "Découvrez cet événement: ${event.titre}";
    // Share.share(text);
  }
}