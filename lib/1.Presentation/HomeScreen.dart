import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/1.Presentation/WatherDetails.dart';
import 'package:weather_app/2.Domain/WeatherApi/GetDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  TextEditingController _controller = TextEditingController();
  RxBool _searching = false.obs;

  @override
  void initState() {
    super.initState();
    _loadPreviousSearch();
  }

  Future<void> _loadPreviousSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? previousSearch = prefs.getString('previousSearch');
    if (previousSearch != null) {
      setState(() {
        _controller.text = previousSearch;
      });
    }
  }

  Future<void> _saveSearch(String search) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('previousSearch', search);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
             decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFff0000), Color.fromARGB(255, 216, 242, 44)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(
                vertical: height * .1, horizontal: width * .05),
            child: Column(
              children: [
                Text("Weather App", style: TextStyle(fontSize: height * .05 , color: Color.fromARGB(255, 230, 255, 9) ),),
                SizedBox(height: height * .1),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),

                    // Search Icon
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _searching.value = true;
                        _saveSearch(_controller.text);
                        getWeatherDetails()
                            .getWeather(
                                city: _controller.text.replaceAll(" ", ""))
                            .then((value) {
                          if (value != null && value.length > 0) {
                            Get.to(WeatherDetails(
                                cityName: value[0],
                                weatherMain: value[1],
                                weatherDescription: value[2],
                                temperature: value[3],
                                feelsLike: value[4],
                                windSpeed: value[5],
                                humidity: value[6],
                                weatherIcon: value[7],
                                ));
                          } else {
                            Get.snackbar("Error", "No Such City Found");
                          }
                          _searching.value = false;
                        });
                      },
                    ),

                    // Clear Icon
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                      },
                    ),
                    hintText: 'Enter The City Name',
                  ),
                  onChanged: (text) {
                    _saveSearch(text);
                  },
                  onTapOutside: (event) {
                    FocusScope.of(context).unfocus();
                  },
                  onSubmitted: (value) {
                    _searching.value = true;
                    _saveSearch(value);
                    getWeatherDetails()
                        .getWeather(city: _controller.text.replaceAll(" ", ""))
                        .then((value) {
                      if (value != null && value.length > 0) {
                        Get.to(WeatherDetails(
                            cityName: value[0],
                            weatherMain: value[1],
                            weatherDescription: value[2],
                            temperature: value[3],
                            feelsLike: value[4],
                            windSpeed: value[5],
                            humidity: value[6],
                            weatherIcon: value[7], ),
                            );
                      } else {
                        Get.snackbar("Error", "No Such City Found");
                      }
                      _searching.value = false;
                    });
                  },
                ),
                SizedBox(height: height * .02),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      _searching.value = true;
                      _saveSearch(_controller.text);
                      getWeatherDetails()
                          .getWeather(
                              city: _controller.text.replaceAll(" ", ""))
                          .then((value) {
                        if (value != null && value.length > 6) {
                          Get.to(WeatherDetails(
                              cityName: value[0],
                              weatherMain: value[1],
                              weatherDescription: value[2],
                              temperature: value[3],
                              feelsLike: value[4],
                              windSpeed: value[5],
                              humidity: value[6],
                              weatherIcon: value[7]),);
                        } else {
                          Get.snackbar("Error", "No Such City Found");
                        }
                        _searching.value = false;
                      });
                    } catch (e) {
                      Get.snackbar("Error", "Technical Error");
                    }
                  },
                  child: Text("Search"),
                ),
                Obx(
                  () => Visibility(
                    visible: _searching.value,
                    child: Container(
                      height: height * .3,
                      width: width,
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
