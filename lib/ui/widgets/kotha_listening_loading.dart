import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class KothaListeningLoadingWidget extends StatelessWidget {
  final String responseText;

  const KothaListeningLoadingWidget({super.key, required this.responseText});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Lottie.asset(
                height: 80,
                width: 80,
                'assets/animations/loading.json',
                fit: BoxFit.contain,
                repeat: true,
              ),
            ),
            Text(
              responseText,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[300],
                fontWeight: FontWeight.normal,
                fontSize: 20,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ],
    );
  }
}
