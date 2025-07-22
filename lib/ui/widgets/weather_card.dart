import 'package:flutter/material.dart';
import 'package:kotha_ai/model/weather_model.dart';
import 'package:intl/intl.dart';

class KothaWeatherCard extends StatelessWidget {
  final List<Color> gradientColors;
  final WeatherModel weather;

  const KothaWeatherCard({
    super.key,
    required this.gradientColors,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    List<Color> gradientWeatherColorsContainer = [
      const Color(0xff312d59),
      const Color(0xff403c71),
    ];
    final now = DateTime.now();
    final formattedDate = DateFormat('d MMM, EEEE').format(now);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Here is your result for today’s forecast!",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          height: 300,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: gradientColors),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Today's",
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontSize: 14),
                  ),
                  Text(
                    formattedDate,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Header (Temp + icon)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${weather.temp.toStringAsFixed(1)}°C",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    'assets/sun_cloud.png', // Make sure this asset exists
                    width: 50,
                    height: 50,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // City & Condition
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoBox(
                    "City",
                    weather.city,
                    gradientWeatherColorsContainer,
                  ),
                  _buildInfoBox(
                    "Condition",
                    "${weather.condition}%",
                    gradientWeatherColorsContainer,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Wind & Humidity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoBox(
                    "Humidity",
                    "${weather.humidity}%",
                    gradientWeatherColorsContainer,
                  ),
                  _buildInfoBox(
                    "Wind",
                    "${weather.wind} km/h",
                    gradientWeatherColorsContainer,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoBox(String label, String value, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(colors: gradient),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
