import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../widget/common_app_bar.dart';

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
                      Text(
                        _yearMonthText,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('수입',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF7C7C7C),
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text('+600,000',
                              style: TextStyle(color: Color(0xFF5C57FE), fontSize: 16)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('지출',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF7C7C7C),
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text('-600,000', style: TextStyle(color: Colors.red, fontSize: 16)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('잔액',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF7C7C7C),
                                  fontWeight: FontWeight.bold)),
                          SizedBox(height: 2),
                          Text('W600,000', style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// 달력
              Expanded(
                child: TableCalendar(
                  locale: 'ko_KR',
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  headerVisible: false,
                  sixWeekMonthsEnforced: true,
                  daysOfWeekHeight: 32,
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.bold), // 평일 기본 스타일
                  ),
                  rowHeight: rowHeight,
                  calendarBuilders: CalendarBuilders(
                    dowBuilder: (context, day) {
                      // 요일 인덱스 0 = 일요일, 6 = 토요일
                      if (day.weekday == DateTime.sunday) {
                        return Center(
                          child: Text(
                            '일',
                            style: TextStyle(
                                color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else if (day.weekday == DateTime.saturday) {
                        return Center(
                          child: Text(
                            '토',
                            style: TextStyle(
                                color: Colors.blue, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(
                            _weekdayString(day.weekday), // 아래 함수로 요일 표시
                            style: TextStyle(color: Colors.black87, fontSize: 16),
                          ),
                        );
                      }
                    },
                    defaultBuilder: (context, day, focusedDay) {
                      return Container(
                        margin: const EdgeInsets.all(4), // 셀 간격 약간 띄우기
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100, // 흐릿한 회색 배경 (border 없이 깔끔)
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                        ),
                      );
                    },
                    todayBuilder: (context, day, focusedDay) {
                      return Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      );
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      return Container(
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.amber, width: 2), // 테두리 강조
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.transparent,
                        ),
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          ),
                        ),
                      );
                    },
                    outsideBuilder: (context, day, focusedDay) {
                      // 이번 달 아닌 날짜 처리
                      return Container(
                        margin: const EdgeInsets.all(4),
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(fontSize: 14, color: Colors.grey), // 흐릿한 색
                          ),
                        ),
                      );
                    },
                  ),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });

                    _showBottomSheet(context, selectedDay);
                  },
                  onPageChanged: (_focusedDay) {
                    setState(() {
                      _focusedDay = _focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.deepPurpleAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
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
                  // 버튼 눌렀을 때 실행할 코드
                },
                backgroundColor: Color(0xFFA79BFF),
                shape: const CircleBorder(),
                child: Icon(
                  Icons.add, // + 아이콘
                  color: Colors.white, // 아이콘 색
                  size: 36, // 아이콘 크기 (기본 24)
                ),
              ))
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

  String _weekdayString(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return '월';
      case DateTime.tuesday:
        return '화';
      case DateTime.wednesday:
        return '수';
      case DateTime.thursday:
        return '목';
      case DateTime.friday:
        return '금';
      default:
        return '';
    }
  }

  void _showBottomSheet(BuildContext context, DateTime selectedDay) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('여기에 수입/지출 추가 폼이 들어갈 수 있어요.'),
              // 추가로 TextField, Button 등 필요한 위젯 배치 가능)
            ],
          ),
        );
      },
    );
  }
}
