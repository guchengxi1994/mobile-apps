import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarReminderPage extends StatefulWidget {
  CalendarReminderPage({Key? key}) : super(key: key);

  @override
  _CalendarReminderPageState createState() => _CalendarReminderPageState();
}

class _CalendarReminderPageState extends State<CalendarReminderPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    // print("current locale ${Localizations.localeOf(context).languageCode}");
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    if (_calendarFormat != format) {
                      setState(() => _calendarFormat = format);
                    }
                  });
                },
                locale: 'zh_CN',
                onDaySelected: (selected, focused) {
                  print(selected);
                  print(focused);
                },
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2015, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31)),
          ],
        ),
      ),
    );
  }
}
