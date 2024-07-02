import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class getWeatherDetails {
  var api_key = dotenv.env['API_KEY'];

  Future getWeather({required String city}) async {
    try {
      List list = [];
      String req =
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$api_key";
      var uri = Uri.parse(req);
      var responce = await http.get(uri);
      var data = json.decode(responce.body);

      //name ,
      list.add(data["name"].toString());

      //Weather only ( like = cloudy,rainy)
      list.add(data["weather"][0]["main"].toString());

      //Weather description ( like = overcast clouds)
      list.add(data["weather"][0]["description"].toString());

      //Temperature
      list.add(((data["main"]["temp"]).toInt() - 273).toString());

      //Feels Like
      list.add(((data["main"]["feels_like"]).toInt() - 273).toString());

      //wind speed
      list.add((data["wind"]["speed"]).toString());

      //Humidity
      list.add((data["main"]["humidity"]).toString());

      //WeatherIcon
      list.add(data["weather"][0]["icon"].toString());

      debugPrint(list.toString());
      if( list.length > 0) return list;
    } catch (e) {
      debugPrint(e.toString());
      if(e == NoSuchMethodError) Get.snackbar("Error", "No such City Found ");
      // Get.snackbar("Error", "Technical default: $e} ");
    }
  }
}
