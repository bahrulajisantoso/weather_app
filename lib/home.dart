import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/bloc/weather_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _selectedCity;
  List _cities = [];

  List<String> _getAllCity(List weathers) {
    List<String> cities = [];

    for (var weather in weathers) {
      if (weather.containsKey('name') && weather['name'] is List) {
        String name = weather['name'][1];
        cities.add(name);
      }
    }
    return cities;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM yyyy HH.mm').format(now);

    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<WeatherBloc, WeatherState>(
          builder: (context, state) {
            if (state is WeatherLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is WeatherSuccess) {
              _cities = _getAllCity(state.weathers);
              _selectedCity ??= _cities.isNotEmpty ? _cities[0] : null;

              // cuaca
              var weather = state.weathers[_cities.indexOf(_selectedCity)]
                  ['parameter'][6];
              List timerangeWeather = weather['timerange'];
              var weatherToday = timerangeWeather.sublist(0, 4);

              // suhu
              var temperature = state.weathers[_cities.indexOf(_selectedCity)]
                  ['parameter'][5];
              List timerangeTemp = temperature['timerange'];
              var timerangeToday = timerangeTemp.sublist(0, 4);
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    color: Colors.blue,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Jawa Timur',
                          style: TextStyle(fontSize: 24),
                        ),
                        _dropDown(cities: _cities),
                        Text(
                          getCurrentTemperature(timerangeToday, now),
                          style: const TextStyle(fontSize: 72),
                        ),
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          getCurrentWeather(weatherToday, now, 'desc'),
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 12),
                        Image.asset(
                            getCurrentWeather(weatherToday, now, 'icon')),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarExample(
                      weathers: state.weathers,
                      cities: _cities,
                      city: _selectedCity.toString(),
                    ),
                  ),
                ],
              );
            }
            return const Center(
              child: Text('No Data'),
            );
          },
        ),
      ),
    );
  }

  Widget _dropDown({
    Widget? underline,
    Widget? icon,
    TextStyle? style,
    TextStyle? hintStyle,
    Color? dropdownColor,
    Color? iconEnabledColor,
    required List cities,
  }) =>
      DropdownButton<String>(
        value: _selectedCity,
        underline: underline,
        icon: icon,
        dropdownColor: dropdownColor,
        style: style,
        iconEnabledColor: iconEnabledColor,
        onChanged: (String? newValue) {
          setState(() {
            _selectedCity = newValue;
          });
        },
        hint: Text("Select City", style: hintStyle),
        items: cities
            .map((x) => DropdownMenuItem<String>(value: x, child: Text(x)))
            .toList(),
      );
}

// cuaca code
Map<int, Map<String, dynamic>> weatherCodeMap = {
  0: {'desc': 'Cerah', 'icon': 'assets/clear.png'},
  1: {'desc': 'Cerah Berawan', 'icon': 'assets/cloudy.png'},
  2: {'desc': 'Cerah Berawan', 'icon': 'assets/cloudy.png'},
  3: {'desc': 'Berawan', 'icon': 'assets/cloudy.png'},
  4: {'desc': 'Berawan Tebal', 'icon': 'assets/cloudy.png'},
  5: {'desc': 'Udara Kabur', 'icon': 'assets/haze.png'},
  10: {'desc': 'Asap', 'icon': 'assets/smoke.png'},
  45: {'desc': 'Kabut', 'icon': 'assets/fog.png'},
  60: {'desc': 'Hujan Ringan', 'icon': 'assets/rain.png'},
  61: {'desc': 'Hujan Sedang', 'icon': 'assets/rain.png'},
  63: {'desc': 'Hujan Lebat', 'icon': 'assets/rain.png'},
  80: {'desc': 'Hujan Lokal', 'icon': 'assets/rain.png'},
  95: {'desc': 'Hujan Petir', 'icon': 'assets/thunderstorm.png'},
  97: {'desc': 'Hujan Petir', 'icon': 'assets/thunderstorm.png'},
};

Map<String, dynamic> getWeatherInfo(int weatherCode) {
  return weatherCodeMap[weatherCode] ??
      {'desc': 'Data cuaca tidak tersedia', 'icon': 'assets/unknown.png'};
}

// cuaca
String getCurrentWeather(List timerangeWeather, DateTime now, String show) {
  int currentHour = now.hour;
  int weatherIndex;

  if (currentHour >= 0 && currentHour < 6) {
    weatherIndex = 0;
  } else if (currentHour >= 6 && currentHour < 12) {
    weatherIndex = 1;
  } else if (currentHour >= 12 && currentHour < 18) {
    weatherIndex = 2;
  } else {
    weatherIndex = 3;
  }

  int weatherCode = int.parse(timerangeWeather[weatherIndex]['value']);
  Map<String, dynamic> weatherInfo = getWeatherInfo(weatherCode);

  return weatherInfo[show];
}

// suhu
String getCurrentTemperature(List timerangeTemp, DateTime now) {
  int currentHour = now.hour;
  int tempIndex;

  if (currentHour >= 0 && currentHour < 6) {
    tempIndex = 0;
  } else if (currentHour >= 6 && currentHour < 12) {
    tempIndex = 1;
  } else if (currentHour >= 12 && currentHour < 18) {
    tempIndex = 2;
  } else {
    tempIndex = 3;
  }

  String temperature = timerangeTemp[tempIndex]['value'][0].toString();
  return '$temperature°C';
}

class TabBarExample extends StatefulWidget {
  final List weathers;
  final List cities;
  final String city;
  const TabBarExample(
      {super.key,
      required this.weathers,
      required this.cities,
      required this.city});

  @override
  State<TabBarExample> createState() => _TabBarExampleState();
}

/// [AnimationController]s can be created with `vsync: this` because of
/// [TickerProviderStateMixin].
class _TabBarExampleState extends State<TabBarExample>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: const <Widget>[
            Tab(
              text: 'Hari ini',
            ),
            Tab(
              text: 'Besok',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildWeatherList(
              weathers: widget.weathers,
              day: 'today',
              cities: widget.cities,
              selectedCity: widget.city),
          _buildWeatherList(
              weathers: widget.weathers,
              day: 'tomorrow',
              cities: widget.cities,
              selectedCity: widget.city),
        ],
      ),
    );
  }
}

Widget _buildWeatherList(
    {required List weathers,
    required String day,
    required List cities,
    required String selectedCity}) {
  String cityName = selectedCity;
  int cityIndex = cities.indexOf(cityName);

// suhu
  var temperature = weathers[cityIndex]['parameter'][5];
  List timerangeTemp = temperature['timerange'];
  var timerangeToday = timerangeTemp.sublist(0, 4);
  var timerangeTomorrow = timerangeTemp.sublist(4, 8);

// waktu
  final List time = ['00.00', '06.00', '12.00', '18.00'];

// cuaca
  var weather = weathers[cityIndex]['parameter'][6];
  List timerangeWeather = weather['timerange'];
  var weatherToday = timerangeWeather.sublist(0, 4);
  var weatherTomorrow = timerangeWeather.sublist(4, 8);

  weatherShow(String show, int index, List day) {
    int weatherCode = int.parse(day[index]['value']);
    Map<String, dynamic> weatherInfo = getWeatherInfo(weatherCode);
    return weatherInfo[show];
  }

  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: 4,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: (day == 'today')
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    time[index].toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${weatherShow('desc', index, weatherToday)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Image.asset(
                    '${weatherShow('icon', index, weatherToday)}',
                    height: 72,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${timerangeToday[index]['value'][0]}°C',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    time[index].toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${weatherShow('desc', index, weatherTomorrow)}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Image.asset(
                    '${weatherShow('icon', index, weatherTomorrow)}',
                    height: 72,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${timerangeTomorrow[index]['value'][0]}°C',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      );
    },
  );
}
