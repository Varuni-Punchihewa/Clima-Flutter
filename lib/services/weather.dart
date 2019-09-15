import 'location.dart';
import 'networking.dart';

const URL = 'https://api.openweathermap.org/data/2.5';
const apiKey = '7bdd91a64982ba4cdf49cec47a663d47';

class WeatherModel {
  Future<dynamic> getCityWeather(String city) async {
    NetworkHelper networkHelper =
        NetworkHelper('$URL/find?q=$city&appid=$apiKey&units=metric');
    var decodedData = await networkHelper.getData();
    return decodedData;
  }

  Future<dynamic> getLocationWeather() async {
    Location location = new Location();
    await location.getCurrentLocation();

    NetworkHelper networkHelper = NetworkHelper(
        '$URL/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric');
    var decodedData = await networkHelper.getData();
    return decodedData;
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
