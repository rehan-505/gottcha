import 'package:location/location.dart';

class UserModel {
  String? name;
  String? image;
  String? email;
  bool? isReady;
  double? latitude;
  double? longitude;
  bool eliminated;

  UserModel({this.name, this.image, this.email,this.isReady,this.longitude,this.latitude, this.eliminated=false});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json["name"],
      image: json["image"],
      email: json["email"],
      isReady: json["isReady"],
      latitude: json['latitude'],
      longitude: json['longitude'],
      eliminated: json['eliminated'],


    );
  }


  Map<String, dynamic> toJson() {
    return {
      "name": this.name,
      "image": this.image,
      "email": this.email,
      'isReady': this.isReady,
      'latitude' : latitude,
      'longitude' : longitude,
      'eliminated': eliminated
    };
  }
//

}
