import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Weather {
  final int current;
  final String name;
  final String day;
  final int wind;
  final int humidity;
  final String image;
  final String location;
  final String time;

  Weather(
      {required this.name, //
      required this.day, //
      required this.wind, //
      required this.humidity, //
      required this.image, //
      required this.current, //
      required this.location,
      required this.time //
      });
}

String appId = "1860bce2df1280e6bd0eda2a527c0178";

Future<List> fetchData(String lat, String lon, String city) async {
  var url =
      "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&appid=$appId";
  var response = await http.get(Uri.parse(url));
  DateTime date = DateTime.now();
  if (response.statusCode == 200) {
    var res = json.decode(response.body);
    int hour = int.parse(DateFormat("hh").format(date));
    //current temp
    var current = res["current"];
    Weather currentTemp = Weather(
        current: current["temp"]?.round() ?? 0,
        name: current["weather"][0]["main"].toString(),
        day: DateFormat("EEEE dd MMMM").format(date),
        wind: current["wind_speed"]?.round() ?? 0,
        humidity: current["humidity"]?.round() ?? 0,
        time: Duration(hours: hour + 1).toString().split(":")[0] + ":00",
        location: city,
        image: findIcon(current["weather"][0]["main"].toString(), true));

    List<Weather> todayWeather = [];
    int hourLocal = int.parse(DateFormat("hh").format(date));
    for (var i = 0; i < 7; i++) {
      var hourlyRes = res["hourly"];
      // print(hourlyRes);
      var hourly = Weather(
          current: hourlyRes[i]["temp"]?.round() ?? 0,
          name: hourlyRes[i]["weather"][0]["main"].toString(),
          day: DateFormat("EEEE dd MMMM").format(date),
          wind: hourlyRes[i]["wind_speed"]?.round() ?? 0,
          humidity: hourlyRes[i]["humidity"]?.round() ?? 0,
          location: city,
          image: findIcon(hourlyRes[i]["weather"][0]["main"].toString(), true),
          time: Duration(hours: hourLocal + i + 1).toString().split(":")[0] +
              ":00");
      // time: (hour + i + 1).toString().split(":")[0] + ":00");
      todayWeather.add(hourly);
    }

    // Seven day Weather
    List<Weather> sevenday = [];
    for (var i = 1; i < 8; i++) {
      String day = DateFormat("EEEE")
          .format(DateTime(date.year, date.month, date.day + i + 1))
          .substring(0, 3);
      var dailyRes = res["daily"];
      // print(dailyRes);
      var hourly = Weather(
          current: dailyRes[i]["temp"]["day"]?.round() ?? 0,
          name: dailyRes[i]["weather"][0]["main"].toString(),
          day: day,
          wind: dailyRes[i]["wind_speed"]?.round() ?? 0,
          humidity: dailyRes[i]["humidity"]?.round() ?? 0,
          location: city,
          image: findIcon(dailyRes[i]["weather"][0]["main"].toString(), true),
          time: Duration(hours: hourLocal + i + 1).toString().split(":")[0] +
              ":00");
      sevenday.add(hourly);
    }

    return [currentTemp, todayWeather, sevenday];
  }
  return [null, null, null];
}

//findicon
String findIcon(String name, bool type) {
  if (type) {
    switch (name) {
      case "Clouds":
        return "assets/cloudy.png";
        break;
      case "Rain":
        return "assets/rainy.png";
        break;
      case "Drizzle":
        return "assets/rainy.png";
        break;
      case "Thunderstorm":
        return "assets/thunder.png";
        break;
      case "Snow":
        return "assets/snowy.png";
        break;
      default:
        return "assets/sunny.png";
    }
  }
  throw () {
    debugPrint(type.toString());
    print("error at findIcon");
  };
}

// Weather currentTemp = Weather(
//     current: 30,
//     image: "assets/sunny.png",
//     name: "Sunny",
//     day: "Monday, 17 May",
//     wind: 13,
//     humidity: 24,
//     location: "Bandar Baru Bangi");

class cityModel {
  final String name;
  final String lat;
  final String lon;
  cityModel({required this.name, required this.lat, required this.lon});
}

var cityJSON;
//return city name based on city name match case
Future<cityModel?> fetchCity(String cityName) async {
  if (cityJSON == null) {
    String link =
        "https://raw.githubusercontent.com/dr5hn/countries-states-cities-database/master/cities.json";
    var response = await http.get(Uri.parse(link));
    if (response.statusCode == 200) {
      cityJSON = json.decode(response.body);
    }
  }
  for (var i = 0; i < cityJSON.length; i++) {
    if (cityJSON[i]["name"].toString().toLowerCase() ==
        cityName.toLowerCase()) {
      return cityModel(
          name: cityJSON[i]["name"].toString(),
          lat: cityJSON[i]["latitude"].toString(),
          lon: cityJSON[i]["longitude"].toString());
    }
  }
  return null;
}
