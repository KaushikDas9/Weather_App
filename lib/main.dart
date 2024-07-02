import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/1.Presentation/HomeScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const GetMaterialApp(home: HomePage()));
}
