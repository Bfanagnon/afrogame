import 'package:json_annotation/json_annotation.dart';

part 'event_models.g.dart';
/* flutter pub run build_runner build */

enum EventStatus {
  encours,
  valider,
  payer,
  passer,
  nonpayer,
  supprimer,
}

enum MediaType {
  photo,
  video,
}

enum TypeJeu {
  AlaUne,
  Gbovian,
  Match,
}
enum UserRole { ADM, USER }

@JsonSerializable()
class UserData {
  String? id;
  String? pseudo = "";
  late String? oneIgnalUserid = "";
  List<String>? userabonnements=[];

  String? nom;
  String? prenom;
  String? telephone;
  String? urlImage;
  int? solde=0;
  double? note=0.1;
  String? adresse = "";
  String? email = "";
  String? genre = "";
  String? codeParrainage;
  String? codeParrain;
  String? role;


  UserData();

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
@JsonSerializable()

class AppDefaultData {
  String? id;
  String? app_link;

  late int app_version = 0;
  late String app_logo = "";
  late String one_signal_api_key = "";
  late String one_signal_app_id = "";
  late String one_signal_app_url = "";
  // int? default_point_new_comment=2;

  AppDefaultData();

  factory AppDefaultData.fromJson(Map<String, dynamic> json) => _$AppDefaultDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppDefaultDataToJson(this);
}


// EventData model
@JsonSerializable()
class EventData {
  String? id;
  String? userId;
  String? titre;
  String? description;
  String? statut;
  String? idCategorie;
  String? categorie;
  String? idSousCategorie;
  String? sousCategorie;
  String? typeJeu;
  String? urlPosition;
  double? longitude;
  double? latitude;
  String? pays;
  String? ville;
  String? adresse;
  List<String>? userslikes=[];
  List<String>? usersVues=[];
  int? vue=0;
  int? like=0;
  int? partage=0;
  int? commentaire=0;
  int? createdAt;
  int? updatedAt;
  int? nombreJourAvantDisparition;
  int? date;
  List<Map<String, String?>> medias = [
  ];
  String? urlMedia;
  String? typeMedia;
  @JsonKey(includeFromJson: false, includeToJson: false)
  UserData? user;

  EventData();

  factory EventData.fromJson(Map<String, dynamic> json) => _$EventDataFromJson(json);

  Map<String, dynamic> toJson() => _$EventDataToJson(this);
}

// CategorieEvent model
@JsonSerializable()
class CategorieEvent {
  String? id;
  String? titre;
  String? description;

  CategorieEvent();

  factory CategorieEvent.fromJson(Map<String, dynamic> json) => _$CategorieEventFromJson(json);

  Map<String, dynamic> toJson() => _$CategorieEventToJson(this);
}

// SousCategorieEvent model
@JsonSerializable()
class SousCategorieEvent {
  String? id;
  String? titre;
  String? description;

  SousCategorieEvent();

  factory SousCategorieEvent.fromJson(Map<String, dynamic> json) => _$SousCategorieEventFromJson(json);

  Map<String, dynamic> toJson() => _$SousCategorieEventToJson(this);
}

// OptionSousCategorieEvent model
@JsonSerializable()
class OptionSousCategorieEvent {
  String? id;
  String? titre;

  OptionSousCategorieEvent();

  factory OptionSousCategorieEvent.fromJson(Map<String, dynamic> json) => _$OptionSousCategorieEventFromJson(json);

  Map<String, dynamic> toJson() => _$OptionSousCategorieEventToJson(this);
}
