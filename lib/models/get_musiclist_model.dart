// To parse this JSON data, do
//
//     final getmusic = getmusicFromJson(jsonString);

import 'dart:convert';

Getmusic getmusicFromJson(String str) => Getmusic.fromJson(json.decode(str));

String getmusicToJson(Getmusic data) => json.encode(data.toJson());

class Getmusic {
  List<ListElement>? list;

  Getmusic({
    this.list,
  });

  factory Getmusic.fromJson(Map<String, dynamic> json) => Getmusic(
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "list": List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class ListElement {
  String? name;
  String? description;
  String? imageUrl;
  String? audioUrl;

  ListElement({
    this.name,
    this.description,
    this.imageUrl,
    this.audioUrl,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    name: json["name"],
    description: json["description"],
    imageUrl: json["image_url"],
    audioUrl: json["audio_url"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "description": description,
    "image_url": imageUrl,
    "audio_url": audioUrl,
  };
}
