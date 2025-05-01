import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:wonmore_budget/widget/bottom_sheet_widget.dart';
import 'package:wonmore_budget/widget/calendar_widget.dart';
import 'package:wonmore_budget/widget/common_app_bar.dart';
import 'package:wonmore_budget/widget/custom_drawer.dart';
import 'package:wonmore_budget/widget/record_input_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 연도,월 텍스트용 포맷터
  String get _yearMonthText {
    return '${_focusedDay.year}.${_focusedDay.month}월';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final paddingTop = MediaQuery.of(context).padding.top;
    final paddingBottom = MediaQuery.of(context).padding.bottom;

    // 고정 영역 높이 정의
    const appBarHeight = 56.0;
    const bottomNavBarHeight = 56.0;
    const yearMonthHeight = 56.0;
    const summaryHeight = 80.0;
    const daysOfWeekHeight = 32.0;
    const minAdHeight = 50.0;
    const dayMargin = 48.0;

    // 캘린더 + 광고 쓸 수 있는 전체 높이
    final calendarAreaHeight = screenHeight -
        paddingTop -
        paddingBottom -
        appBarHeight -
        bottomNavBarHeight -
        yearMonthHeight -
        summaryHeight -
        dayMargin;

    // usable 캘린더 높이 (요일줄 빼고)
    final usableCalendarHeight = calendarAreaHeight - daysOfWeekHeight - minAdHeight;

    // rowHeight 계산 (6줄 기준)
    final rowHeight = (usableCalendarHeight / 6).floorToDouble();

    // 광고 최종 높이 계산
    final realAdHeight = calendarAreaHeight - (rowHeight * 6) - daysOfWeekHeight;

    return Scaffold(
      appBar: CommonAppBar(),
      drawer: CustomDrawer(),
      body: Stack(
        children: [
          Column(
            children: [
              /// 연도.월 + 화살표 구현
              Container(
                color: Color(0xFFF1F1FD),
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _onLeftArrow,
                        icon: Icon(Icons.chevron_left),
                      ),
                      GestureDetector(
                        onTap: () async {
                          final pickedDate = await showMonthPicker(
                            context: context,
                            initialDate: _focusedDay,
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              _focusedDay = pickedDate;
                            });
                          }
                        },
                        child: Text(
                          _yearMonthText,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        onPressed: _onRightArrow,
                        icon: Icon(Icons.chevron_right),
                      )
                    ],
                  ),
                ),
              ),

              /// 수입/지출/잔액 정보
              /// 추후 숫자 부분은 변수로 변경 후 상태관리 필요
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: _buildSummaryItem('수입', 800000, '+')),
                      Expanded(child: _buildSummaryItem('지출', 600000, '-')),
                      Expanded(child: _buildSummaryItem('잔액', 200000)),
                    ],
                  ),
                ),
              ),

              /// 달력
              Expanded(
                child: CalendarWidget(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  rowHeight: rowHeight,
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });

                    _showBottomSheet(context, selectedDay, rowHeight);
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _focusedDay = focusedDay;
                    });
                  },
                ),
              ),

              /// 광고 추가
              SizedBox(
                height: realAdHeight,
                child: Container(
                  color: Colors.grey,
                  child: Center(child: Text('광고 자리')),
                ),
              ),
            ],
          ),

          /// FAB 추가하여 일정 추가 버튼 생성
          Positioned(
            right: 16,
            bottom: realAdHeight + 16,
            child: FloatingActionButton(
              onPressed: () {
                final now = DateTime.now();
                showDialog(
                  context: context,
                  builder: (_) => RecordInputDialog(initialDate: now),
                );
              },
              backgroundColor: Color(0xFFA79BFF),
              shape: const CircleBorder(),
              child: Icon(
                Icons.add, // + 아이콘
                color: Colors.white, // 아이콘 색
                size: 36, // 아이콘 크기 (기본 24)
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onLeftArrow() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
    });
  }

  void _onRightArrow() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
    });
  }

  Widget _buildSummaryItem(String label, int amount, [String prefix = '\\']) {
    final formattedAmount = NumberFormat('#,###').format(amount);
    final displayAmount = '$prefix$formattedAmount';
    final Color amountColor = switch (prefix) {
      '+' => Color(0xFF6A50FF),
      '-' => Colors.red,
      _ => Colors.black,
    };
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style:
              const TextStyle(fontSize: 20, color: Color(0xFF7C7C7C), fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          displayAmount,
          style: TextStyle(
            fontSize: 16,
            color: amountColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ],
    );
  }

  void _showBottomSheet(BuildContext context, DateTime selectedDay, double rowHeight) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return CustomBottomSheet(selectedDay: selectedDay, rowHeight: rowHeight);
      },
    );
  }
}
