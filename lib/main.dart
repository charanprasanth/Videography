import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/video_editor_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const VideographyApp());
}

class VideographyApp extends StatelessWidget {
  const VideographyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Trimmer',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6C63FF),
          secondary: const Color(0xFF48CAE4),
          surface: const Color(0xFF13131f),
        ),
        scaffoldBackgroundColor: const Color(0xFF0d0d14),
        fontFamily: 'sans-serif',
        useMaterial3: true,
      ),
      home: const VideoEditorScreen(),
    );
  }
}
