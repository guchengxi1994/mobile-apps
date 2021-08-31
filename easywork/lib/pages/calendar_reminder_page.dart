import 'package:easywork/models/models.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarReminderPage extends StatefulWidget {
  CalendarReminderPage({Key? key}) : super(key: key);

  @override
  _CalendarReminderPageState createState() => _CalendarReminderPageState();
}

class _CalendarReminderPageState extends State<CalendarReminderPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late final ValueNotifier<List<Event>> _selectedEvents;
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();

  late CalendarBuilders<Event> _calendarBuilders;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    _calendarBuilders =
        CalendarBuilders(markerBuilder: (context, time, events) {
      int l = _getEventsForDay(time).length;
      // List l = _getEventsForDay(time);
      return Container(
        width: 30,
        height: 20,
        alignment: Alignment.bottomRight,
        child: Text(
          l == 0 ? "" : l.toString(),
          style: TextStyle(color: Colors.red),
        ),
      );
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("current locale ${Localizations.localeOf(context).languageCode}");
    return Scaffold(
      body: Column(
        children: [
          TableCalendar<Event>(
              calendarBuilders: _calendarBuilders,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  if (_calendarFormat != format) {
                    setState(() => _calendarFormat = format);
                  }
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              onDayLongPressed: (time1, time2) {
                print("添加一个事件");
                print(time1);
                print(time2);
              },
              locale: 'zh_CN',
              onDaySelected: _onDaySelected,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2015, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31)),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 4.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          onTap: () => print('${value[index]}'),
                          title: Text('${value[index]}'),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        // print(selectedDay);
        // print(focusedDay);
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        // _rangeStart = null; // Important to clean those
        // _rangeEnd = null;
        // _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }
}
