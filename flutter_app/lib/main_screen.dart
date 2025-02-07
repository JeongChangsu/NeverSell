import 'package:flutter/material.dart';
import 'package:flutter_app/dca_screen.dart';

class MainScreen extends StatefulWidget {
  final void Function(ThemeMode) updateThemeMode;

  const MainScreen({
    Key? key,
    required this.updateThemeMode,
  }) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0; // 하단 탭 인덱스 (0=홈, 1=DCA, 2=설정)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'NeverSell',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: 'DCA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '설정',
          ),
        ],
      ),
      // 탭에 따라 화면 변경
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildHomeTab(),
          const DcaScreen(),
          _buildSettingsTab(),
        ],
      ),
    );
  }

  //region [각 탭 화면 빌더]

  /// 1) 홈 탭
  Widget _buildHomeTab() {
    // 가짜 데이터 예시
    final currentBtcPrice = 23000.12;  // 현재 BTC 가격(예시)
    final myReturnRate = 12.34;        // 누적 수익률(예시)
    final dcaTodayAsset = 'BTC';       // 오늘 DCA 구매 코인(예시)

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 현재 BTC 가격 카드
          _buildInfoCard(
            title: '현재 비트코인 가격',
            content: '\$${currentBtcPrice.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 16),

          // 나의 누적 수익률
          _buildInfoCard(
            title: '나의 누적 수익률',
            content: '${myReturnRate.toStringAsFixed(2)}%',
          ),
          const SizedBox(height: 16),

          // 오늘의 DCA 구매 코인
          _buildInfoCard(
            title: '오늘 DCA 구매 코인',
            content: dcaTodayAsset,
          ),
        ],
      ),
    );
  }

  /// 2) DCA 탭
  /// dca_screen.dart에서 만든 DcaScreen을 그대로 삽입
  /// (Scaffold가 내부에 없으므로 직접 탭 바디에 넣어도 OK)
  // -> const DcaScreen() 를 IndexedStack children에 삽입했음

  /// 3) 설정 탭 (다크모드/라이트모드 스위치)
  Widget _buildSettingsTab() {
    // 현재 ThemeMode가 dark인지 light인지 판단은
    // 사실 MaterialApp에서 themeMode를 직접 확인하기 어려움.
    // 간단히 "현재 스위치" 여부만 유지하려면 StatefulWidget에서 bool? 값을 관리해도 됨.
    // 여기서는 'isDarkMode'를 Theme.of(context).brightness로 대충 추론(조금 단순화).
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ListTile(
            title: const Text('다크 모드'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                // value == true => 다크 모드, false => 라이트 모드
                setState(() {
                  isDarkMode = value;
                });
                widget.updateThemeMode(
                    value ? ThemeMode.dark : ThemeMode.light);
              },
            ),
          ),
          // 필요하다면 시스템 모드도 추가해 보세요 (라디오버튼 3개 중 택1 등)
          // ...
        ],
      ),
    );
  }

  //endregion

  /// 홈 탭에서 재사용할 단순 정보 카드
  Widget _buildInfoCard({required String title, required String content}) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(12),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
