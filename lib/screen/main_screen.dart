import 'package:flutter/material.dart';
import 'package:wonmore_budget/screen/analysis_screen.dart';
import 'package:wonmore_budget/screen/home_screen.dart';
import 'package:wonmore_budget/screen/my_info_screen.dart';
import 'package:wonmore_budget/screen/my_wallet_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // 화면 선택 위치
  List<Widget> _screenType = [
    HomeScreen(), // 홈 화면(달력 가계부)
    AnalysisScreen(), // 수입/지출 분석 화면
    MyWalletScreen(), // 카드 실적 등 관리 화면
    MyInfoScreen(), // 내 정보 화면
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screenType.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Color(0xFFF1F1FD),
        selectedItemColor: Color(0xFF6A50FF),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        iconSize: 40,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}
