import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/2.Domain/WeatherApi/GetDetails.dart';
import 'package:intl/intl.dart';

class WeatherDetails extends StatefulWidget {
  var cityName = "".obs;
  var weatherMain = "".obs;
  var weatherDescription = "".obs;
  var temperature = "".obs;
  var feelsLike = "".obs;
  var windSpeed = "".obs;
  var humidity = "".obs;
  var weatherIcon = "".obs;

  WeatherDetails(
      {required String cityName,
      required String weatherMain,
      required String weatherDescription,
      required String temperature,
      required String feelsLike,
      required String windSpeed,
      required String humidity,
      required String weatherIcon,
      super.key})
      : cityName = cityName.obs,
        weatherMain = weatherMain.obs,
        weatherDescription = weatherDescription.obs,
        temperature = temperature.obs,
        feelsLike = feelsLike.obs,
        windSpeed = windSpeed.obs,
        weatherIcon = weatherIcon.obs,
        humidity = humidity.obs;

  @override
  State<WeatherDetails> createState() => _WeatherDetailsState();
}

class _WeatherDetailsState extends State<WeatherDetails> {
  DateTime now = DateTime.now();
  var _loading = false.obs;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Obx(() => SafeArea(
          child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Color(0xFFff0000),
                title: Text("Weather Details"),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () {
                        _onRefresh();
                      }),
                  SizedBox(
                    width: width * .02,
                  )
                ]),
            body: _loading.value == true
                ? Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFff0000),
                            Color(0xFFffff00)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    height: height * .9,
                    width: width,
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : Stack(alignment: Alignment.topCenter, children: [
                    Container(
                      height: height,
                      width: width,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFff0000),
                            Color(0xFFffff00)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: height * .03,
                        ),
                        //Date And Time
                        ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: height * .01,
                                      vertical: height * .006),
                                  child: Text(
                                      " ${DateFormat('EEE').format(now)}, ${DateFormat('MMM').format(now)} ${now.day}",
                                      style:
                                          TextStyle(fontSize: height * .013)),
                                ))),
                        SizedBox(height: height * .02),
                        //Place
                        Text(
                          widget.cityName.value.toString(),
                          style: TextStyle(fontSize: height * .03),
                        ),
                        SizedBox(height: height * .044),
                        //Condition
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network("https://openweathermap.org/img/w/${widget.weatherIcon}.png"),
                            Text(widget.weatherDescription.value.toString())
                          ],
                        ),
                        SizedBox(height: height * .035),
                        //Temperature
                        Text("${widget.temperature.value.toString()}°C",
                            style: TextStyle(fontSize: height * .13)),
                        SizedBox(height: height * .035),
                        //Feels Like
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.thermostat),
                            Text(
                                "Feels likes ${widget.feelsLike.value.toString()}°C")
                          ],
                        ),
                        SizedBox(height: height * .1),

                        //Wind and Humidity
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.air),
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: widget.windSpeed.value
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: height * .05,
                                                    color: Colors.black)),
                                            const TextSpan(
                                                text: " km/h",
                                                style: TextStyle(
                                                    color: Colors.black))
                                          ])),
                                          const Text("Wind")
                                        ]),
                                  ),
                                )),
                            ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Card(
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.water_drop_outlined),
                                          RichText(
                                              text: TextSpan(children: [
                                            TextSpan(
                                                text: widget.humidity.value
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: height * .05,
                                                    color: Colors.black)),
                                            const TextSpan(
                                                text: " %",
                                                style: TextStyle(
                                                    color: Colors.black))
                                          ])),
                                          const Text("Humidity")
                                        ]),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ]),
          ),
        ));
  }

  Future<void> _onRefresh() async {
    try {
      _loading.value = true;
      getWeatherDetails().getWeather(city: widget.cityName.value).then((value) {
        if (value != null && value.length > 6) {
          widget.cityName.value = value[0];
          widget.weatherMain.value = value[1];
          widget.weatherDescription.value = value[2];
          widget.temperature.value = value[3];
          widget.feelsLike.value = value[4];
          widget.windSpeed.value = value[5];
          widget.humidity.value = value[6];
          _loading.value = false;
        } else {
          _loading.value = false;
          Get.snackbar("Error", "No Such City Found");
        }
      });
    } catch (e) {
      Get.snackbar("Error", "Technical Error");
    }
  }
}
