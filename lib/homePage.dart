import 'package:flutter/material.dart';
import 'package:tacres_draft/dataset.dart';
import 'package:tacres_draft/recordACT.dart';
import 'package:tacres_draft/asthContTest.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:geocoding/geocoding.dart';

StreamController<String> streamController = StreamController<String>();

Weather? currentTemp;
List<Weather>? todayWeather;
List<Weather>? sevenday;

String lat = "3.1477";
String lon = "101.6940";
String city = "Kuala Lumpur";

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Position position;
  late List<Placemark> placemarks;

  dailyForecast dailyforecast = const dailyForecast();

  getData() async {
    fetchData("$lat", "$lon", city).then((value) {
      currentTemp = value[0];
      todayWeather = value[1];
      sevenday = value[2];
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
              onPressed: () {
                // function for update current location
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
              icon: const Icon(Icons.location_on_outlined, size: 30),
              color: Colors.black,
            )
          ],
        ),
        backgroundColor: const Color(0xffBFC0C2),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text('TACRES APPS')),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.black),
                title: const Text('Asthma Control Test'),
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
              ListTile(
                leading: const Icon(Icons.feed, color: Colors.black),
                title: const Text('ACT Records'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.of(context).push(
                      // ignore: prefer_const_constructors
                      MaterialPageRoute(builder: (context) => recordACT()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.menu_book, color: Colors.black),
                title: const Text('Weather Map'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading:
                    const Icon(Icons.language_rounded, color: Colors.black),
                title: const Text('App Language'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.black,
                ),
                title: const Text('Settings'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Log Out'),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
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
                TodayWeather(),
                currChance(),
                hourlyForecast(),
                weatherUpdate(),
                healthRec(),
                dailyForecast(),
                Text("")

                // TodayWeather()
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
              // Text(currentTemp.day,
              //     style: TextStyle(
              //       fontSize: 18,
              //     ))
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
                      Text(currentTemp!.wind.toString() + "m/s")
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

class currChance extends StatelessWidget {
  const currChance({Key? key}) : super(key: key);

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
                              decoration: const BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: const [
                                  Text("                Medium               ",
                                      style: TextStyle(
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
                              decoration: const BoxDecoration(
                                  color: Colors.greenAccent,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                children: const [
                                  Text(
                                      "                   Low                   ",
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
      height: 90,
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
                Text("Update",
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
              padding: EdgeInsets.all(5),
              child: Column(
                children: const [
                  Text(
                      "Rain in the morning and afternoon with high humidity rising to 97%.")
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
      height: 130,
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
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: const <Widget>[
                  ListTile(
                    title: Text(
                      "1. Stay indoor, it will help you reduce the exposure to rain and humidity.",
                      style: TextStyle(fontSize: 14),
                    ),
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                  ),
                  ListTile(
                    title: Text("2. Wear a scarf or mask to cover your nose.",
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
