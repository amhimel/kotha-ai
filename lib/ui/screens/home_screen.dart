import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kotha_ai/ui/widgets/custom_appbar.dart';
import 'package:kotha_ai/ui/widgets/kotha_greeting_card.dart';
import 'package:kotha_ai/ui/widgets/kotha_listening_card.dart';
import 'package:kotha_ai/ui/widgets/kotha_mic_button.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter/services.dart';
import 'package:torch_light/torch_light.dart';
import 'package:kotha_ai/model/weather_model.dart';
import 'package:kotha_ai/services/weather_service.dart';
import '../widgets/weather_card.dart';
import 'package:geolocator/geolocator.dart';

late stt.SpeechToText _speech;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _response = "How can I help you today?";
  bool _isListening = false;
  bool _showWeather = false;
  bool _isLoadingWeather = false;
  WeatherModel? _weatherData;
  final WeatherService _weatherService = WeatherService();
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  //get current location method
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print("Speech status: \$status"),
        onError: (error) => print("Speech error: \$error"),
      );

      if (available) {
        setState(() => _isListening = true);

        _speech.listen(
          onResult: (result) {
            setState(() {
              _response = result.recognizedWords;

              if (result.finalResult) {
                _isListening = false;
                _speech.stop();
                processCommand(_response);
              }
            });
          },
          localeId: 'en_US',
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void processCommand(String command) async {
    final cmd = command.toLowerCase();

    if (cmd.contains("flash") || cmd.contains("torch")) {
      if (cmd.contains("off")) {
        toggleFlashlight(false);
        _response = "Turning off flashlight";
      } else if (cmd.contains("on")) {
        toggleFlashlight(true);
        _response = "Turning on flashlight";
      } else {
        _response = "Do you want to turn the flashlight on or off?";
      }
      speak(_response);
    } else if (cmd.startsWith("call ")) {
      final name = cmd.replaceFirst("call ", "").trim();
      _response = "Calling \$name...";
      speak(_response);
      _callContactByName(name);
    } else if (cmd.contains("open facebook")) {
      _response = "Opening Facebook... 🌐";
      const url = 'https://facebook.com';
      _launchURL(url);
    } else if (cmd.contains("today's weather") ||
        cmd.contains("weather today")) {
      setState(() {
        _response = "Today’s weather...";
        _isLoadingWeather = true;
        _showWeather = true;
      });

      try {
        final position = await _determinePosition();
        final weather = await _weatherService.fetchWeatherByLocation(
          position.latitude,
          position.longitude,
        );
        if (weather != null) {
          setState(() {
            _isLoadingWeather = false;
            _weatherData = weather;
            _response = "Here is your result for today’s forecast!";
          });
        } else {
          setState(() {
            _response = "Could not fetch weather data.";
          });
        }
      } catch (e) {
        print(e);
        setState(() {
          _response = "Location access error.";
          _showWeather = false;
        });
      }
      Future.delayed(const Duration(seconds: 10), () {
        setState(() {
          _showWeather = false;
          _response = "How can I help you today?";
        });
      });

      speak(_response);
    } else {
      _response = "Sorry, I didn’t understand that.";
    }
    speak(_response);
    setState(() {});
  }

  Future<void> toggleFlashlight(bool turnOn) async {
    try {
      if (turnOn) {
        await TorchLight.enableTorch();
      } else {
        await TorchLight.disableTorch();
      }
    } catch (e) {
      print("Flash error: \$e");
    }
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      final canLaunch = await canLaunchUrl(uri);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        print("Could not launch \$url");
      }
    } catch (e) {
      print("Exception: \$e");
    }
  }

  Future<void> _callContactByName(String name) async {
    try {
      if (!await FlutterContacts.requestPermission()) {
        setState(() {
          _response = "Contact permission denied.";
        });
        return;
      }

      final contacts = await FlutterContacts.getContacts(withProperties: true);

      final match = contacts.firstWhere(
        (c) => c.displayName.toLowerCase().contains(name.toLowerCase()),
        orElse: () => Contact(),
      );

      if (match.phones.isNotEmpty) {
        final phone = match.phones.first.number;
        if (await _requestCallPermission()) {
          _directPhoneCall(phone);
        } else {
          _response = "Please allow phone call permission.";
          setState(() {});
        }
      } else {
        setState(() {
          _response = "No contact found named \$name.";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Error: \${e.toString()}";
      });
    }
    speak(_response);
    setState(() {
      _response = 'How can I help you today?';
    });
  }

  Future<bool> _requestCallPermission() async {
    final status = await Permission.phone.request();
    return status.isGranted;
  }

  void speak(String text) async {
    await tts.setLanguage('en-US');
    await tts.speak(text);
  }

  Future<void> _directPhoneCall(String number) async {
    const platform = MethodChannel('com.kothaai/call');
    try {
      final result = await platform.invokeMethod('callNumber', {
        'number': number,
      });
      print(result);
    } on PlatformException {
      print("Failed to call: \${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Color> gradientColorsScaffold = [Color(0xff1B1745), Color(0xff1A1731)];
    List<Color> gradientColorsContainer = [
      Color(0xff282452),
      Color(0xff201C46),
    ];

    return Scaffold(
      appBar: CustomAppbar(),
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
                if (_isLoadingWeather)
                  KothaListeningCard(
                    responseText: _response,
                    gradientColors: gradientColorsContainer,
                    isLoading: true,
                  )
                else if (_showWeather && _weatherData != null)
                  KothaWeatherCard(
                    gradientColors: gradientColorsContainer,
                    weather: _weatherData!,
                  )
                else if (!_isListening)
                  KothaGreetingCard(
                    gradientColors: gradientColorsContainer,
                    responseText: _response,
                  )
                else
                  KothaListeningCard(
                    responseText: _response,
                    gradientColors: gradientColorsContainer,
                  ),

                KothaMicButton(
                  isListening: _isListening,
                  toggleListening: _toggleListening,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
