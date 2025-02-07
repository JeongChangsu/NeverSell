import 'dart:async';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final void Function(ThemeMode) updateThemeMode;

  const SplashScreen({
    Key? key,
    required this.updateThemeMode,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 2초 뒤에 로그인 화면으로 이동
    Timer(const Duration(seconds: 2), () {
      // 실제: 세션 있으면 '/main', 없으면 '/login'
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      backgroundColor: isLight ? Colors.white : Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pie_chart,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'NeverSell',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isLight ? Colors.black : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
