import 'package:flutter/material.dart';
import '../utils/apifile.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:convert';
class Climate extends StatefulWidget {
  @override
  _ClimateState createState() => _ClimateState();
}

class _ClimateState extends State<Climate> {

  void showStuff() async {
    Map data = await getWeather(util.apiId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Home"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                showStuff();
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Image(
              image: AssetImage('images/umbrella.png'),
              height: 1250.0,
              width: 600.0,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: Text("Dahaka",
              style: cityStyle(),
            ),
          ),
          Center(
            child: Image(
              image: AssetImage('images/light_rain.png'),
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(30.0, 90.0, 0.0, 0.0),
            child: updateTempWidget("Dhaka"
          ),
          ),
        ],
      ),
    );
  }


}

Widget updateTempWidget(String city) {
  return FutureBuilder(
      future: getWeather(util.apiId, city == null ? util.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        //where we get all of the json data, we setup widgets etc.
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return Container(
            margin: const EdgeInsets.fromLTRB(30.0, 250.0, 0.0, 0.0),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    content['main']['temp'].toString() + " F",
                    style: new TextStyle(
                        fontStyle: FontStyle.normal,
                        fontSize: 49.9,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                  subtitle: new ListTile(
                    title: new Text(
                      "Humidity: ${content['main']['humidity'].toString()}\n"
                          "Min: ${content['main']['temp_min'].toString()} F\n"
                          "Max: ${content['main']['temp_max'].toString()} F ",
                      style: extraData(),
                    ),
                  ),
                )
              ],
            ),
          );
        } else {
          return Container();
        }
      });
}


Future<Map>getWeather(String appId,String city)async {

  String apiUrl =
      'https://api.openweathermap.org/data/2.5/weather?q=$city&appid='
      '${util.apiId}&units=imperial';
  //http://api.openweathermap.org/data/2.5/weather?q=vehari&appid=5fe06374c9ac1b1981c3c1b80da00d77&units=metric
  http.Response response = await http.get(apiUrl);

  return json.decode(response.body);
}

TextStyle cityStyle() {
  return TextStyle(
    color: Colors.white,
    fontSize: 22.9,
    fontStyle: FontStyle.italic,
  );
}

TextStyle tempStyle() {
  return TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 49.9);
}

TextStyle extraData() {
  return TextStyle(
      color: Colors.white70, fontStyle: FontStyle.normal, fontSize: 17.0);
}