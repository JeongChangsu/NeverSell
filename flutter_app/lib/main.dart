import 'package:flutter/material.dart';
import 'package:flutter_app/splash_screen.dart';
import 'package:flutter_app/login_screen.dart';
import 'package:flutter_app/main_screen.dart';


void main() {
  runApp(const NeverSellApp());
}

class NeverSellApp extends StatefulWidget {
  const NeverSellApp({Key? key}) : super(key: key);

  @override
  State<NeverSellApp> createState() => _NeverSellAppState();
}

class _NeverSellAppState extends State<NeverSellApp> {
  // 테마모드(기본은 시스템 설정 따라감)
  ThemeMode _themeMode = ThemeMode.system;

  /// 외부에서 호출해 라이트/다크 테마를 전환할 수 있게 하는 함수
  void updateThemeMode(ThemeMode newMode) {
    setState(() {
      _themeMode = newMode;
    });
  }

  // 오렌지 컬러를 메인으로 하는 MaterialColor 예시
  static const MaterialColor _primarySwatch = MaterialColor(
    0xFFFFA500,
    <int, Color>{
      50: Color(0xFFFFF8E1),
      100: Color(0xFFFFECB3),
      200: Color(0xFFFFE082),
      300: Color(0xFFFFD54F),
      400: Color(0xFFFFCA28),
      500: Color(0xFFFFC107),
      600: Color(0xFFFFB300),
      700: Color(0xFFFFA000),
      800: Color(0xFFFF8F00),
      900: Color(0xFFFF6F00),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeverSell',
      debugShowCheckedModeBanner: false,

      // 라이트 테마
      theme: ThemeData(
        primarySwatch: _primarySwatch,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),

      // 다크 테마
      darkTheme: ThemeData(
        primarySwatch: _primarySwatch,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),

      // 실제 적용할 테마모드
      themeMode: _themeMode,

      // 초기 라우트
      initialRoute: '/',

      // 라우트 설정
      routes: {
        '/': (context) => SplashScreen(updateThemeMode: updateThemeMode),
        '/login': (context) => LoginScreen(updateThemeMode: updateThemeMode),
        '/main': (context) => MainScreen(updateThemeMode: updateThemeMode),
      },
    );
  }
}
