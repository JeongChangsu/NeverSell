import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  final void Function(ThemeMode) updateThemeMode;

  const LoginScreen({
    Key? key,
    required this.updateThemeMode,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // 예시: 로그인 처리
  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // TODO: 실제 로그인 API 호출 & 토큰 발급 etc.
    // 여기서는 성공 가정 후 메인화면 이동
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '로그인',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isLight ? Colors.black : Colors.white,
                ),
              ),
              const SizedBox(height: 40),

              _buildLabel('이메일'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hintText: 'example@domain.com',
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 20),

              _buildLabel('비밀번호'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hintText: '비밀번호 입력',
                obscureText: true,
              ),

              const SizedBox(height: 30),

              // 로그인 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '로그인',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // 회원가입 등 추가 버튼도 가능
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('계정이 없으신가요? '),
                  GestureDetector(
                    onTap: () {
                      // 회원가입 화면 등으로 이동 처리
                    },
                    child: Text(
                      '회원가입',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isLight ? Colors.grey.shade100 : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
