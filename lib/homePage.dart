import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tacres_draft/authenticate/sign_in.dart';
import 'package:tacres_draft/dataset.dart';
import 'package:tacres_draft/recordACT.dart';
import 'package:tacres_draft/asthContTest.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';
import 'dart:convert';
import 'package:tacres_draft/services/database.dart';
import 'package:tacres_draft/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:tacres_draft/services/auth.dart';
import 'package:tacres_draft/wrapper.dart';

StreamController<String> streamController = StreamController<String>();

Weather? currentTemp;
List<Weather>? todayWeather;
List<Weather>? sevenday;
AirQualityIndex? currentAqi;

String lat = "3.1477";
String lon = "101.6940";
String city = "Kuala Lumpur";

var currentACTScore = 0;
var previousACTScore = 0;
var currentAirQualityIndex = 0;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Position position;
  late List<Placemark> placemarks;

  final AuthService _auth = AuthService();

  dailyForecast dailyforecast = const dailyForecast();

  getData() async {
    fetchData("$lat", "$lon", city).then((value) {
      currentTemp = value[0];
      todayWeather = value[1];
      sevenday = value[2];
      setState(() {});
    });
    fetchDataAqi("$lat", "$lon").then((valueAqi) {
      currentAqi = valueAqi[0];
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _determinePosition(); //dont delete, will produce error
    getData();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    return position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(currentTemp!.location, style: TextStyle(fontSize: 17.0)),
          centerTitle: true,
          backgroundColor: Colors.white,
          titleTextStyle: Theme.of(context).textTheme.headline6,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(
                  Icons.sort_rounded,
                  color: Colors.black,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Update Your Current Location?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'No'),
                      child: const Text('No'),
                    ),
                    TextButton(
                      // onPressed: () => Navigator.pop(context, 'OK'),
                      onPressed: () {
                        Navigator.pop(context, 'Yes');
                        lat = position.latitude.toString();
                        lon = position.longitude.toString();
                        setState(() async {
                          _determinePosition();
                          placemarks = await placemarkFromCoordinates(
                              position.latitude, position.longitude);
                          city = placemarks.elementAt(0).locality.toString();
                          getData();
                        });
                      },

                      child: const Text('Yes'),
                    ),
                  ],
                ),
              ),
              icon: const Icon(Icons.location_on_outlined, size: 30),
              color: Colors.black,
            )
          ],
        ),
        backgroundColor: const Color(0xffBFC0C2),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 100,
                margin: EdgeInsets.fromLTRB(0, 50, 0, 20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: AssetImage("assets/icon-tacres.png"),
                      fit: BoxFit.contain),
                ),
              ),
              const Text(
                'Treate Asthma Climate Region Experience System',
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              Divider(color: Colors.grey),
              ListTile(
                selectedTileColor: Colors.blue[300],
                tileColor: Colors.white,
                leading: const Icon(Icons.edit, color: Colors.black),
                title: const Text('Asthma Control Test',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.of(context).push(
                      // ignore: prefer_const_constructors
                      MaterialPageRoute(
                          builder: (context) => asthContTest(
                              currentWeather: currentTemp!.name.toString())));
                  // Navigator.pop(context);
                },
              ),
              Divider(color: Colors.grey),
              ListTile(
                selectedTileColor: Colors.blue[300],
                tileColor: Colors.white,
                leading: const Icon(Icons.feed, color: Colors.black),
                title: const Text('ACT Records',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.of(context).push(
                      // ignore: prefer_const_constructors
                      MaterialPageRoute(builder: (context) => recordACT()));
                },
              ),
              Divider(color: Colors.grey),
              ListTile(
                tileColor: Colors.white,
                leading: const Icon(Icons.menu_book, color: Colors.black),
                title: const Text('Weather Map',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () {},
              ),
              Divider(color: Colors.grey),
              ListTile(
                tileColor: Colors.white,
                leading:
                    const Icon(Icons.language_rounded, color: Colors.black),
                title: const Text('App Language',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(color: Colors.grey),
              ListTile(
                tileColor: Colors.white,
                leading: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                title: const Text('Settings',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(color: Colors.grey),
              ListTile(
                tileColor: Colors.white,
                title: const Text('Log Out',
                    style: TextStyle(
                      color: Colors.black,
                    )),
                onTap: () async {
                  // Navigator.pop(context);
                  previousACTScore = 0;
                  currentACTScore = 0;
                  _auth.signOutAuth();
                  Navigator.of(context).push(
                      // ignore: prefer_const_constructors
                      MaterialPageRoute(builder: (context) => Wrapper()));
                },
              ),
            ],
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text("$lat    ${lon}"),
                // Text(AuthService().giveMyUid()),
                TodayWeather(),
                currChance(),
                hourlyForecast(),
                weatherUpdate(),
                healthRec(),
                dailyForecast(),
                UserInformation(),
                previousChanceCalc(),
              ],
            ),
          ),
        ));
  }
}

class TodayWeather extends StatefulWidget {
  const TodayWeather({Key? key}) : super(key: key);

  @override
  State<TodayWeather> createState() => _TodayWeatherState();
}

class _TodayWeatherState extends State<TodayWeather> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      // height: 50,
      child: Column(
        children: [
          Image(
            image: AssetImage(currentTemp!.image),
            height: 60,
          ),
          Center(
              child: Column(
            children: [
              Text(
                currentTemp!.current.toString() + "°C",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              Text(currentTemp!.name + ": " + currentTemp!.description,
                  style: TextStyle(
                    fontSize: 13,
                  )),
              SizedBox(
                height: 10,
              )
            ],
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Row(
                    children: [
                      Image(
                        image: AssetImage("assets/drop.png"),
                        height: 15,
                      ),
                      SizedBox(width: 10),
                      Text(currentTemp!.humidity.toString() + "%")
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Image(
                        image: AssetImage("assets/wind.png"),
                        height: 15,
                      ),
                      SizedBox(width: 10),
                      Text(currentTemp!.wind.toString() + "m/s")
                    ],
                  )
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text("AQI",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Text(calcAqi(currentAqi!.aqi))
                    ],
                  )
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

String calcAqi(int value) {
  switch (value) {
    case 1:
      return "Good";
    case 2:
      return "Fair";
    case 3:
      return "Moderate";
    case 4:
      return "Poor";
    case 5:
      return "Very Poor";
    default:
      return "No Data";
  }
}

class hourlyForecast extends StatefulWidget {
  const hourlyForecast({Key? key}) : super(key: key);

  @override
  State<hourlyForecast> createState() => _hourlyForecastState();
}

class _hourlyForecastState extends State<hourlyForecast> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 200,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Column(
                children: const [
                  Text("Hourly Forecast",
                      style: TextStyle(fontWeight: FontWeight.w800),
                      textAlign: TextAlign.left),
                ],
              ),
            ),
            Flexible(
                flex: 9,
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  // margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                  scrollDirection: Axis.horizontal,
                  //tambah kat sini
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      hourlyWidget(todayWeather![0]),
                      hourlyWidget(todayWeather![1]),
                      hourlyWidget(todayWeather![2]),
                      hourlyWidget(todayWeather![3]),
                      hourlyWidget(todayWeather![4]),
                      hourlyWidget(todayWeather![5]),
                      hourlyWidget(todayWeather![6]),
                    ],
                  ),
                ))
          ],
        ));
  }
}

class hourlyWidget extends StatelessWidget {
  final Weather weather;
  hourlyWidget(this.weather);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
      width: 80,
      decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Image(
            image: AssetImage(weather.image),
            height: 40,
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  weather.time + " am",
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage("assets/thermometer.png"),
                            height: 10,
                          ),
                          Text(weather.current.toString() + "°C"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage("assets/drop.png"),
                            height: 10,
                          ),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Text(weather.humidity.toString() + "%"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage("assets/wind.png"),
                            height: 10,
                          ),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Text(weather.wind.toString() + "m/s"),
                        ],
                      ),

                      //Text(weather.current.toString() + "°C"),
                      // Text(weather.name.toString()),
                      // Text(weather.humidity.toString() + "%"),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

String calcAsthChancExac(int value) {
  // ignore: unnecessary_null_comparison
  if (value > 0 && value <= 15) {
    return "                High               ";
  } else if (value >= 16 && value <= 20) {
    return "               Medium              ";
  } else if (value >= 21 && value <= 25) {
    return "                Low                ";
  } else {
    return "              No Data              ";
  }
}

calcAsthChancExacColor(int value) {
  // ignore: unnecessary_null_comparison
  if (value > 0 && value <= 15) {
    return Colors.redAccent;
  } else if (value >= 16 && value <= 20) {
    return Colors.orangeAccent;
  } else if (value >= 21 && value <= 25) {
    return Colors.greenAccent;
  } else {
    return Colors.white;
  }
}

class currChance extends StatelessWidget {
  //FirebaseFirestore.instance.collection('act-record').doc('ACT_Score');

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: const BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Row(
          children: <Widget>[
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  margin: EdgeInsets.only(right: 2.0),
                  padding: EdgeInsets.all(10),
                  height: 100,
                  // width: 180,
                  // height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Container(
                              // decoration: const BoxDecoration(
                              //     color: Colors.blue,
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(10))),
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: const [
                                  Text("Current chance of asthma exacerbation",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800))
                                ],
                              ))),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      calcAsthChancExacColor(currentACTScore),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Text(calcAsthChancExac(currentACTScore),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800))
                                ],
                              )))
                    ],
                  ),
                )),
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  margin: EdgeInsets.only(left: 2.0),
                  padding: EdgeInsets.all(10),
                  height: 100,
                  // width: 180,
                  // height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: <Widget>[
                      Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: Container(
                              // decoration: const BoxDecoration(
                              //     color: Colors.blue,
                              //     borderRadius:
                              //         BorderRadius.all(Radius.circular(10))),
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: const [
                                  Text("Previous chance of asthma exacerbation",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800))
                                ],
                              ))),
                      Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                              decoration: BoxDecoration(
                                  color:
                                      calcAsthChancExacColor(previousACTScore),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: [
                                  Text(calcAsthChancExac(previousACTScore),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800))
                                ],
                              )))
                    ],
                  ),
                )),
          ],
        ));
  }
}

class weatherUpdate extends StatelessWidget {
  const weatherUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
      height: 100,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              children: const [
                Text("Weather Update",
                    style: TextStyle(fontWeight: FontWeight.w800),
                    textAlign: TextAlign.left)
              ],
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(currentTemp!.name +
                      " weather with temperature of " +
                      currentTemp!.current.toString() +
                      "°C, humidity up to " +
                      currentTemp!.humidity.toString() +
                      "% and Air Quality Index that is " +
                      calcAqi(currentAqi!.aqi) +
                      ".")
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class healthRec extends StatelessWidget {
  const healthRec({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
      padding: EdgeInsets.all(10),
      height: 140,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Container(
            child: Column(
              children: const [
                Text(
                  "Health Recommendation",
                  // textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w800),
                )
              ],
            ),
          ),
        ),
        Flexible(
            flex: 3,
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      "1. " +
                          healthRecommendation1(currentTemp!.name.toString()),
                      // ignore: prefer_const_constructors
                      style: TextStyle(fontSize: 14),
                    ),
                    // ignore: prefer_const_constructors
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  ),
                  ListTile(
                    title: Text(
                        "2. " +
                            healthRecommendation2(currentTemp!.name.toString()),
                        style: TextStyle(fontSize: 14)),
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  )
                ],
              ),
            ))
      ]),
    );
  }
}

String healthRecommendation1(weatherName) {
  if (weatherName == "Rain" ||
      weatherName == "Clouds" ||
      weatherName == "Drizzle") {
    return "Wrap a scarf around nose and mouth loosely";
  } else if (weatherName == "Thunderstorm") {
    return "Stay inside before, during and after the storm.";
  } else {
    return "Keep an eye on air quality index and pollen forecast";
  }
}

String healthRecommendation2(weatherName) {
  if (weatherName == "Rain" ||
      weatherName == "Clouds" ||
      weatherName == "Drizzle") {
    return "The scarf can prevent airways being shocked by cold air.";
  } else if (weatherName == "Thunderstorm") {
    return "Keep the windows shut to prevent pollen from entering the house.";
  } else {
    return "Don't forget to bring reliever inhaler.";
  }
}

class dailyForecast extends StatefulWidget {
  const dailyForecast({Key? key}) : super(key: key);

  @override
  State<dailyForecast> createState() => _dailyForecastState();
}

@override
void initState() {}

class _dailyForecastState extends State<dailyForecast> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        height: 200,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 1,
              fit: FlexFit.loose,
              child: Column(
                children: const [
                  Text("Daily Forecast",
                      style: TextStyle(fontWeight: FontWeight.w800),
                      textAlign: TextAlign.left),
                ],
              ),
            ),
            Flexible(
                flex: 9,
                fit: FlexFit.tight,
                child: SingleChildScrollView(
                  // margin: EdgeInsets.fromLTRB(5, 5, 0, 5),
                  scrollDirection: Axis.horizontal,
                  //tambah kat sini
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      dailyWidget(sevenday![0]),
                      dailyWidget(sevenday![1]),
                      dailyWidget(sevenday![2]),
                      dailyWidget(sevenday![3]),
                      dailyWidget(sevenday![4]),
                      dailyWidget(sevenday![5]),
                      dailyWidget(sevenday![6]),
                    ],
                  ),
                ))
          ],
        ));
  }
}

class dailyWidget extends StatelessWidget {
  final Weather weather;
  dailyWidget(this.weather);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
      width: 80,
      decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Image(
            image: AssetImage(weather.image),
            height: 40,
          ),
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 5,
                ),
                Text(
                  weather.day,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage("assets/thermometer.png"),
                            height: 10,
                          ),
                          Text(weather.current.toString() + "°C"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage("assets/drop.png"),
                            height: 10,
                          ),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Text(weather.humidity.toString() + "%"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage("assets/wind.png"),
                            height: 10,
                          ),
                          // SizedBox(
                          //   width: 10,
                          // ),
                          Text(weather.wind.toString() + "m/s"),
                        ],
                      ),

                      //Text(weather.current.toString() + "°C"),
                      // Text(weather.name.toString()),
                      // Text(weather.humidity.toString() + "%"),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

//https://firebase.flutter.dev/docs/firestore/usage
class UserInformation extends StatefulWidget {
  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('draft-act-record')
      .where('Uid', isEqualTo: AuthService().giveMyUid())
      .orderBy('ACT_Date', descending: true)
      .limit(1)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      child: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              currentACTScore = data['ACT_Score'];
              // item.add(data['ACT_Score']);
              // actScoreArray.add(data['ACT_Score']);
              return Text(data['ACT_Score'].toString(),
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 1));
            }).toList(),
          );
        },
      ),
    );
  }
}

class previousChanceCalc extends StatefulWidget {
  const previousChanceCalc({Key? key}) : super(key: key);

  @override
  State<previousChanceCalc> createState() => _previousChanceCalcState();
}

class _previousChanceCalcState extends State<previousChanceCalc> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance
      .collection('draft-act-record')
      .where('Uid', isEqualTo: AuthService().giveMyUid())
      .orderBy('ACT_Date', descending: true)
      .limit(2)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      // decoration: const BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.all(Radius.circular(10))),
      child: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              previousACTScore = data['ACT_Score'];

              return Text(data['ACT_Score'].toString(),
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 1));
            }).toList(),
          );
        },
      ),
    );
  }
}
