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

//for convert speech to text
late stt.SpeechToText _speech;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _response = "How can I help you today?";
  bool _isListening = false;
  final FlutterTts tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  //after click on button what work done.
  Future<void> _toggleListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) => print("Speech status: $status"),
        onError: (error) => print("Speech error: $error"),
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

                // 🔁 Process the command
                processCommand(_response);
              }
            });
          },
          localeId: 'en_US', // চাইলে 'bn_BD' ব্যবহার করতে পারো
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  void processCommand(String command) async {
    final cmd = command.toLowerCase();

    if (cmd.contains("turn on the light")) {
      _response = "Turning on the light... 💡";
    } else if (cmd.contains("turn off the light")) {
      _response = "Turning off the light";
    } else if (cmd.startsWith("call ")) {
      final name = cmd.replaceFirst("call ", "").trim();
      _response = "Calling $name...";
      speak(_response);
      _callContactByName(name);

    } else if (cmd.contains("play music")) {
      _response = "Playing music... 🎶";
      // You can open a local music player or online URL
    } else if (cmd.contains("open facebook")) {
      _response = "Opening Facebook... 🌐";
      const url = 'https://facebook.com';
      _launchURL(url);
    } else if (cmd.contains("open game")) {
      _response = "Opening your game... 🎮";
      // You can integrate with Android Intent or app launcher plugin
    } else if (cmd.contains("ajker khobor") || cmd.contains("আজকের খবর")) {
      _response = "আজকের শীর্ষ খবর: আজকের তাপমাত্রা ৩২° এবং আকাশ আংশিক মেঘলা।";
    } else {
      _response = "Sorry, I didn’t understand that.";
    }

    speak(_response);
    setState(() {});
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      final canLaunch = await canLaunchUrl(uri);
      print("Can launch: $canLaunch");
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        print("❌ Could not launch $url");
      } else {
        print("✅ Launched $url");
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  //for call command and call those name
  Future<void> _callContactByName(String name) async {
    try {
      // 1️⃣ Permission check
      if (!await FlutterContacts.requestPermission()) {
        setState(() {
          _response = "Contact permission denied.";
        });
        return;
      }

      // 2️⃣ Fetch all contacts with numbers
      final contacts = await FlutterContacts.getContacts(withProperties: true);

      // 3️⃣ Search for contact by name
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
        //final uri = Uri.parse('tel:$phone');
        // if (await canLaunchUrl(uri)) {
        //   await launchUrl(uri);
        //   setState(() {
        //     _response = "Calling $name...";
        //   });
        // } else {
        //   setState(() {
        //     _response = "Could not launch call.";
        //   });
        // }
      } else {
        setState(() {
          _response = "No contact found named $name.";
        });
      }
    } catch (e) {
      setState(() {
        _response = "Error: ${e.toString()}";
      });
    }
    speak(_response);
    setState(() {
      _response = 'How can I help you today?';
    }); // optional if TTS used
  }

  //for direct call permission
  Future<bool> _requestCallPermission() async {
    final status = await Permission.phone.request();
    return status.isGranted;
  }

  //for speaking the response text
  void speak(String text) async {
    await tts.setLanguage('en-US'); // বা 'bn-BD'
    await tts.speak(text);
  }

  Future<void> _directPhoneCall(String number) async {
    const platform = MethodChannel('com.kothaai/call');

    try {
      final result = await platform.invokeMethod('callNumber', {
        'number': number,
      });
      print(result);
    } on PlatformException catch (e) {
      print("Failed to call: ${e.message}");
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
                //👋 Greeting
                !_isListening
                    ? KothaGreetingCard(
                      gradientColors: gradientColorsContainer,
                      responseText: _response,
                    )
                    : KothaListeningCard(
                      responseText: _response,
                      gradientColors: gradientColorsContainer,
                    ),

                // 🎤 Mic Button
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
