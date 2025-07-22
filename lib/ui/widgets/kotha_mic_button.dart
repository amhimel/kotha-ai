import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class KothaMicButton extends StatelessWidget {
  const KothaMicButton({
    super.key,
    required this.isListening,
    required this.toggleListening,
  });

  final bool isListening;
  final VoidCallback toggleListening;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          width: 160,
          child: GestureDetector(
            onTap: toggleListening,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: isListening ? 1.0 : 0.0,
                  child: Lottie.asset(
                    'assets/animations/mic_pulse.json',
                    height: 160,
                    width: 160,
                    fit: BoxFit.cover,
                    repeat: true,
                  ),
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF99FCD1), // Light mint
                        Color(0xFF539FE0), // Blue-ish
                        Color(0xFF0092FF), // Vibrant blue
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xFF0092FF),
                        blurRadius: 20,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.mic, size: 40, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
