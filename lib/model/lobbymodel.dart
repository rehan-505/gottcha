import 'package:gottcha/model/usermodel.dart';

class LobbyModel{
  String? modeType;
  String? area;
  String? time;
  int? lobbyId;
  List<UserModel>? hiders;
  List<UserModel>? searchers;
  bool gameStarted;
  bool? isHidingTime;
  int? hidingTime;
  double? mapZoom;
  double? mapLat;
  double? mapLng;
  bool gameFinished;
  int? noOfSecondsGameLasted;

  LobbyModel(
      {this.modeType,
      this.area,
      this.time,
      this.lobbyId,
      this.hiders,
      this.searchers,
      this.gameStarted = false,
        this.isHidingTime,
        this.hidingTime,
        this.mapZoom,
        this.mapLat,
        this.mapLng,
        this.gameFinished = false,
        this.noOfSecondsGameLasted

      });

  factory LobbyModel.fromJson(Map<String, dynamic> json) {
    return LobbyModel(
      modeType: json["modeType"],
      area: json["area"],
      time: json["time"],
      mapLat: json["mapLat"],
      mapLng: json["mapLng"],
      mapZoom: json["mapZoom"],
      lobbyId: int.parse(json["lobbyId"].toString()),
      hiders: List.of(json["hiders"])
          .map((i) => UserModel.fromJson(i) )
          .toList(),
      searchers: List.of(json["searchers"])
          .map((i) => UserModel.fromJson(i))
          .toList(),
      gameStarted: json['gameStarted']??false,
      isHidingTime: json['isHidingTime']??false,
      hidingTime: json['hidingTime']??0,
      gameFinished: json['gameFinished'] ?? false,
      noOfSecondsGameLasted: json['noOfSecondsGameLasted']

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "modeType": this.modeType,
      "area": this.area,
      "time": this.time,
      "lobbyId": this.lobbyId,
      "isHidingTime": this.isHidingTime,
      "hidingTime": this.hidingTime,
      "hiders": hiders!.map((i) => i.toJson()).toList(),
      "searchers": searchers!.map((i) => i.toJson()).toList(),
      'gameStarted': gameStarted,
      'mapLat': mapLat,
      'mapLng': mapLng,
      'mapZoom': mapZoom,
      'noOfSecondsGameLasted' : noOfSecondsGameLasted
    };
  }
//

}