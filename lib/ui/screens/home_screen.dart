import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _response = "How can I help you today?";
  bool _isListening = false;
  final FlutterTts tts = FlutterTts();

  void _toggleListening() {
    setState(() {
      _isListening = !_isListening;
      _response = _isListening ? "Listening..." : "How can I help you today?";
      speak(_response);
    });
  }

  //for speaking the response text
  void speak(String text) async {
    await tts.setLanguage('en-US'); // বা 'bn-BD'
    await tts.speak(text);
  }

  //custom AppBar
  AppBar _buildAppBar() {
    List<Color> gradientColorsAppBar = [Color(0xff1B1745), Color(0xff1A1731)];
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColorsAppBar,
            //transform: GradientRotation(180)
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColorsScaffold = [Color(0xff1B1745), Color(0xff1A1731)];
    List<Color> gradientColorsContainer = [
      Color(0xff282452),
      Color(0xff201C46),
    ];

    return Scaffold(
      appBar: _buildAppBar(),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColorsScaffold),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 👋 Greeting
                Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //const SizedBox(height: 40),
                    Text(
                      "Ask Kotha",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    //for home
                    Container(
                      padding: EdgeInsets.all(16),
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: gradientColorsContainer,
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
                            "👋 Hi, I'm Kotha",
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),

                          Text(
                            _response,
                            style: Theme.of(
                              context,
                            ).textTheme.headlineSmall?.copyWith(
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
                ),
                // 🎤 Mic Button
                Column(
                  children: [
                    // 🎤 Replace GestureDetector block with Lottie animation
                    SizedBox(
                      height: 160,
                      width: 160,
                      child: GestureDetector(
                        onTap: _toggleListening,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            //if (_isListening)
                            AnimatedOpacity(
                              duration: Duration(milliseconds: 300),
                              opacity: _isListening ? 1.0 : 0.0,
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
                                    // Same as end color
                                    blurRadius: 20,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.mic,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
