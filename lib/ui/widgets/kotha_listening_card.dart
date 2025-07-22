import 'package:flutter/material.dart';
import 'package:kotha_ai/ui/widgets/kotha_listening_loading.dart';
import 'package:kotha_ai/ui/widgets/kotha_listening_non_loading.dart';
import 'package:lottie/lottie.dart';

class KothaListeningCard extends StatelessWidget {
  final String responseText;
  final List<Color> gradientColors;
  final bool isLoading;

  const KothaListeningCard({
    super.key,
    required this.responseText,
    required this.gradientColors,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Listening...",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          height: 250,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: gradientColors),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/robot.png', width: 40, height: 40),
              const SizedBox(height: 20),
              Text(
                "Hi, Kotha",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              isLoading
                  ? KothaListeningLoadingWidget(responseText: responseText)
                  : KothaListeningNonLoadingWidget(responseText: responseText),
            ],
          ),
        ),
      ],
    );
  }
}
