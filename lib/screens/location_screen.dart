import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';

import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  final locationWeather;
  LocationScreen({this.locationWeather});
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  int temp;
  var temperature;
  String name;
  int id;
  String weatherIcon;
  String weatherMessage;
  WeatherModel weatherModel = WeatherModel();

  @override
  void initState() {
    super.initState();
    updateUI(decodedData: widget.locationWeather);
  }

//0 = currentLocation, 1 = cityLocation
  void updateUI({decodedData, int location = 0}) {
    setState(() {
      if (decodedData == null) {
        temp = 0;
        weatherIcon = 'Error';
        weatherMessage = 'Unable to get weather data';
        name = '';
        return;
      }

      getInfo(decodedData, location);

      temp = temperature.toInt();
      weatherIcon = weatherModel.getWeatherIcon(id);
      weatherMessage = weatherModel.getMessage(temp);
    });
  }

  void getInfo(decodedData, location) {
    if (location == 0) {
      id = decodedData['weather'][0]['id'];
      name = decodedData['name'];
      temperature = decodedData['main']['temp'];
    }
    if (location == 1) {
      id = decodedData['list'][0]['id'];
      name = decodedData['list'][0]['name'];
      temperature = decodedData['list'][0]['main']['temp'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async {
                      updateUI(
                          decodedData: await weatherModel.getLocationWeather());
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {
                      var typedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CityScreen(),
                        ),
                      );
                      if (typedName != null) {
                        var cityWeatherData =
                            await weatherModel.getCityWeather(typedName);
                        updateUI(decodedData: cityWeatherData, location: 1);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      '$weatherIcon️',
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherMessage in $name!',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
