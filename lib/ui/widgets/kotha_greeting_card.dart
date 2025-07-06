import 'package:flutter/material.dart';

class KothaGreetingCard extends StatelessWidget {
  final String responseText;
  final List<Color> gradientColors;

  const KothaGreetingCard({
    super.key,
    required this.responseText,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Ask Kotha",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          height: 220,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: gradientColors,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/sound_robot.png',
                width: 40,
                height: 40,
              ),
              const SizedBox(height: 20),
              Text(
                "Hi, I am Kotha",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                responseText,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[300],
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
