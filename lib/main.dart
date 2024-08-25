import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc()..add(GetWeatherEvent()),
      child: const MaterialApp(
        title: 'Flutter Demo',
        // theme: ThemeData(useMaterial3: true),
        home: Home(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
