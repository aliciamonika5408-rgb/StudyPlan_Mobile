import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../theme/app_colors.dart';
import '../services/storage_service.dart';
import '../models/task_model.dart';
import '../widgets/task_card.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Task> _selectedTasks = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _loadTasksForDay(_selectedDay!);
  }

  void _loadTasksForDay(DateTime day) {
    setState(() {
      _selectedTasks = StorageService.getTasksByDate(day);
    });
  }

  List<Task> _getEventsForDay(DateTime day) {
    return StorageService.getTasksByDate(day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text('Kalender', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 2))],
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                selectedDecoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                todayDecoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.3), shape: BoxShape.circle),
                markerDecoration: const BoxDecoration(color: AppColors.urgent, shape: BoxShape.circle),
                markerSize: 6,
                markersMaxCount: 3,
                outsideDaysVisible: false,
                defaultTextStyle: GoogleFonts.poppins(fontSize: 14),
                weekendTextStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.urgent),
                selectedTextStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                todayTextStyle: GoogleFonts.poppins(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
                rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                weekendStyle: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.urgent),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                _loadTasksForDay(selectedDay);
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  _selectedDay != null ? 'Tugas ${DateFormat('d MMM yyyy').format(_selectedDay!)}' : 'Tugas Hari Ini',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('${_selectedTasks.length}', style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _selectedTasks.isEmpty
                ? Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.event_available_rounded, size: 48, color: AppColors.textSecondary.withValues(alpha: 0.3)),
                      const SizedBox(height: 12),
                      Text('Tidak ada tugas', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                    ]),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _selectedTasks.length,
                    itemBuilder: (ctx, i) {
                      return TaskCard(
                        task: _selectedTasks[i],
                        onTap: () async {
                          final result = await Navigator.of(context).pushNamed('/detail', arguments: _selectedTasks[i].id);
                          if (result == true) _loadTasksForDay(_selectedDay!);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
