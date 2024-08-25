import 'dart:convert';

List<WeatherModel> weatherFromJson(String str) => List<WeatherModel>.from(json
    .decode(str)['data']['forecast']['area']
    .map((x) => WeatherModel.fromJson(x)));

class WeatherModel {
  final String name;

  WeatherModel({
    required this.name,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      name: json['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}
