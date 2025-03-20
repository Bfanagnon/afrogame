import 'dart:async';
import 'dart:typed_data';
import 'package:afroevent/controllers/authController.dart';
import 'package:afroevent/models/event_models.dart';
import 'package:afroevent/pages/share/DateWidget.dart';
import 'package:afroevent/pages/share/FonctionWidget.dart';
import 'package:afroevent/pages/share/messageRequireWidget.dart';
import 'package:afroevent/pages/share/messageView.dart';
import 'package:afroevent/pages/share/navPage.dart';
import 'package:afroevent/pages/share/userProfile.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_video_thumbnail_plus/flutter_video_thumbnail_plus.dart';

import 'auth/login.dart';
import 'details/eventDetail.dart';

class AccueilPage extends StatefulWidget {
  @override
  State<AccueilPage> createState() => _AccueilPageState();
}

class _AccueilPageState extends State<AccueilPage> {
  final AuthController authController = Get.find();
  final StreamController<List<EventData>> _streamController = StreamController<List<EventData>>();
  final Color primaryColor = Color(0xFF2E7D32);
  final Color accentColor = Color(0xFF81C784);

  List<EventData> _allEvents = [];
  List<EventData> get _alaUneEvents => _allEvents.where((e) => e.categorie != "AlaUne").toList();
  List<EventData> get _gameStories => _allEvents.where((e) => e.categorie != "AlaUne").toList();

  @override
  void initState() {
    authController.getEventDatasImages(40).listen(_streamController.add);
    super.initState();
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sport News', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        actions: [UserProfileWidget(user: authController.userLogged)],
      ),
      body: RefreshIndicator(
        onRefresh:()async {
setState(() {
  authController.getEventDatasImages(40).listen(_streamController.add);

});
        },
        child: StreamBuilder<List<EventData>>(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoading();
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            }

            _allEvents = snapshot.data!;
            return CustomScrollView(
              slivers: [
                _buildAlaUneSection(),
                _textSection(),
                _buildGameStoriesSection(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildLoading() => Center(child: CircularProgressIndicator(color: primaryColor));

  Widget _buildEmptyState() => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.event_busy, size: 60, color: Colors.grey),
        SizedBox(height: 20),
        Text('Aucun événement disponible', style: TextStyle(color: Colors.grey)),
      ],
    ),
  );

  SliverToBoxAdapter _buildAlaUneSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text("À la Une", style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            )),
          ),
          CarouselSlider(
            items: _alaUneEvents.map((event) => _alaUneCard(event)).toList(),
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              viewportFraction: 0.7,
              enlargeCenterPage: true,
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
  SliverToBoxAdapter _textSection() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text("Game story", style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            )),
          ),
        ],
      ),
    );
  }

  SliverList _buildGameStoriesSection() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) => _gameStoryItem(_gameStories[index]),
        childCount: _gameStories.length,
      ),
    );
  }

  Widget _alaUneCard(EventData event) {
    return GestureDetector(
      onTap: () => _handleEventTap(event),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        ),
        child: Stack(
          children: [
            _buildMediaPreview(event, height: 250),
            _buildEventOverlay(event),
          ],
        ),
      ),
    );
  }

  Widget _gameStoryItem(EventData event) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => _handleEventTap(event),
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildMediaPreview(event, height: 180),
            _buildEventInfo(event),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaPreview(EventData event, {required double height}) {
    final media = event.medias?.firstWhere(
          (m) => m['type'] == 'image',
      orElse: () => event.medias?.first ?? {},
    );

    if (media?['type'] == 'image') {
      return ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        child: Image.network(
          media!['url']!,
          height: height,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildVideoPreview(event, height),
        ),
      );
    }
    return _buildVideoPreview(event, height);
  }

  Widget _buildVideoPreview(EventData event, double height) {
    final video = event.medias?.firstWhere(
          (m) => m['type'] == 'video',
      orElse: () => {},
    );

    if (video?.isEmpty ?? true) return SizedBox.shrink();

    return FutureBuilder<Uint8List?>(
      future: FlutterVideoThumbnailPlus.thumbnailData(
        video: video!['url']!,
        imageFormat: ImageFormat.jpeg,
        maxWidth: 300,
      ),
      builder: (context, snapshot) {
        return       GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsEventPage(event: event),));
          },
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              image: snapshot.hasData
                  ? DecorationImage(
                  image: MemoryImage(snapshot.data!),
                  fit: BoxFit.cover)
                  : null,
            ),
            child: Center(
              child: Icon(Icons.play_circle_filled,
                  size: 50,
                  color: Colors.white.withOpacity(0.8)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventOverlay(EventData event) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.titre ?? '',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, color: accentColor, size: 16),
                SizedBox(width: 8),
                DateWidget(dateInMicroseconds: event.date!),
                Spacer(),
                Icon(Icons.visibility, color: accentColor, size: 16),
                SizedBox(width: 4),
                Text('${event.vue}',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventInfo(EventData event) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.titre ?? '',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: primaryColor)),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.sports, color: accentColor, size: 16),
              SizedBox(width: 8),
              Text(event.sousCategorie ?? '',
                  style: TextStyle(color: Colors.grey[700])),
              Spacer(),
              DateWidget(dateInMicroseconds: event.date!),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: accentColor, size: 16),
              SizedBox(width: 8),
              Expanded(child: Text('${event.ville}, ${event.pays}',
                  style: TextStyle(color: Colors.grey[700]))),
              Icon(Icons.visibility, color: accentColor, size: 16),
              SizedBox(width: 4),
              Text('${event.vue}', style: TextStyle(color: Colors.grey[700])),
            ],
          ),
        ],
      ),
    );
  }

  void _handleEventTap(EventData event) async {
    if (authController.userLogged.id == null) {
      showLoginRequiredDialog(context, () => Get.to(SimpleLoginScreen()));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailsEventPage(event: event),
      ),
    );
    //
    // await authController.markEventViewed(event);
    // Get.to(DetailsEventPage(event: event));
  }
}