import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<WeatherEvent>((event, emit) async {
      emit(WeatherLoading());
      final response = await http.get(
        Uri.parse(
            "https://data.bmkg.go.id/DataMKG/MEWS/DigitalForecast/DigitalForecast-JawaTimur.xml"),
      );
      final xmlString = response.body;
      final xml2json = Xml2Json();
      xml2json.parse(xmlString);
      final jsonString = xml2json.toParker();
      final jsonObject = json.decode(jsonString)['data']['forecast']['area'];
      emit(WeatherSuccess(weathers: jsonObject));
    });
  }
}
