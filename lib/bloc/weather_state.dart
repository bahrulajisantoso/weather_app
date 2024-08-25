part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherSuccess extends WeatherState {
  final List weathers;
  WeatherSuccess({required this.weathers});
}
