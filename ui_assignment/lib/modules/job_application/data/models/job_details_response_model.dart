// To parse this JSON data, do
//
//     final jobDetailsResponseModel = jobDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

List<JobDetailsResponseModel> jobDetailsResponseModelFromJson(String str) =>
    List<JobDetailsResponseModel>.from(
        json.decode(str).map((x) => JobDetailsResponseModel.fromJson(x)));

String jobDetailsResponseModelToJson(List<JobDetailsResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobDetailsResponseModel {
  String role;
  String location;
  String work;
  String time;
  List<Menu> menu;
  double salary;

  JobDetailsResponseModel({
    required this.role,
    required this.location,
    required this.work,
    required this.time,
    required this.menu,
    required this.salary,
  });

  factory JobDetailsResponseModel.fromJson(Map<String, dynamic> json) =>
      JobDetailsResponseModel(
        role: json["role"],
        location: json["location"],
        work: json["work"],
        time: json["time"],
        menu: List<Menu>.from(json["menu"].map((x) => Menu.fromJson(x))),
        salary: json["salary"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "location": location,
        "work": work,
        "time": time,
        "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
        "salary": salary,
      };
}

class Menu {
  String name;
  List<String> list;

  Menu({
    required this.name,
    required this.list,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        name: json["name"],
        list: List<String>.from(json["list"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "list": List<dynamic>.from(list.map((x) => x)),
      };
}
