import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'chat_screen.dart';
import 'settings_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('hf_token') ?? '';
  runApp(KaiApp(initialToken: token));
}

class KaiApp extends StatelessWidget {
  final String initialToken;
  const KaiApp({super.key, required this.initialToken});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kai',
      debugShowCheckedModeBanner: false,
      theme: KaiTheme.dark(),
      home: MainScreen(initialToken: initialToken),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String initialToken;
  const MainScreen({super.key, required this.initialToken});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String _token;

  @override
  void initState() {
    super.initState();
    _token = widget.initialToken;
  }

  void _onTokenChanged(String token) {
    setState(() => _token = token);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF4F46E5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('K',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ),
              const SizedBox(width: 10),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFA78BFA), Color(0xFF818CF8)],
                ).createShader(bounds),
                child: const Text(
                  'Kai',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.chat_bubble_outline), text: 'צ\'אט'),
              Tab(icon: Icon(Icons.settings_outlined), text: 'הגדרות'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChatScreen(hfToken: _token),
            SettingsScreen(token: _token, onTokenChanged: _onTokenChanged),
          ],
        ),
      ),
    );
  }
}
