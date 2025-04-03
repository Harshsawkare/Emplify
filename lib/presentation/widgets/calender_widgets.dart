import 'package:flutter/material.dart';

import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

/// Data selection for the chips in calender view
DateTime skipAndUpdateDate(
  int selectedIndex,
  int index,
  List<String> options,
  DateTime selectedDate,
) {
  selectedIndex = index;
  switch (options[index]) {
    case Constants.today:
      selectedDate = DateTime.now();
      break;
    case Constants.nextMonday:
      selectedDate = selectedDate.add(const Duration(days: 1));
      while (selectedDate.weekday != 1) {
        selectedDate = selectedDate.add(const Duration(days: 1));
      }
      break;
    case Constants.nextTuesday:
      selectedDate = selectedDate.add(const Duration(days: 1));
      while (selectedDate.weekday != 2) {
        selectedDate = selectedDate.add(const Duration(days: 1));
      }
      break;
    case Constants.after1Week:
      selectedDate = selectedDate.add(const Duration(days: 7));
      break;
  }
  return selectedDate;
}

// Builds a calendar
Widget buildCalendar(
  DateTime month,
  DateTime selectedDate,
  Function(DateTime) onDateSelected,
  bool isLeavingDate,
  DateTime joiningDate,
) {
  List<Widget> days = [];
  DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
  int daysInMonth = DateTime(month.year, month.month + 1, 0).day;
  int startDay = firstDayOfMonth.weekday % 7; // Ensure Sunday is index 0

  // Weekday Headers (Sun - Sat)
  days.add(Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        .map(
          (day) => SizedBox(
            width: 35,
            height: 35,
            child: Center(
              child: Text(
                day,
                style: const TextStyle(
                  color: AppTheme.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        )
        .toList(),
  ));

  List<Widget> currentRow = [];

  // Add empty slots before the 1st of the month
  for (int i = 0; i < startDay; i++) {
    currentRow.add(const SizedBox(
      width: 35,
      height: 35,
    )); // Placeholder spacing
  }

  // Populate the dates
  for (int day = 1; day <= daysInMonth; day++) {
    DateTime date = DateTime(month.year, month.month, day);
    bool isSelected = selectedDate.year == date.year &&
        selectedDate.month == date.month &&
        selectedDate.day == date.day;

    bool isToday = DateTime.now().year == date.year &&
        DateTime.now().month == date.month &&
        DateTime.now().day == date.day;

    bool isDateInPast(DateTime date) {
      DateTime now = joiningDate;
      DateTime joining = DateTime(now.year, now.month, now.day); // Remove time
      DateTime targetDate =
          DateTime(date.year, date.month, date.day); // Remove time

      return targetDate.isBefore(joining);
    }

    bool isPastDate = isDateInPast(date);

    currentRow.add(
      GestureDetector(
        onTap: () => isPastDate && isLeavingDate ? null : onDateSelected(date),
        child: Container(
          margin: const EdgeInsets.all(2),
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : null,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.blue
                  : isToday
                      ? AppTheme.primaryColor
                      : Colors.transparent,
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isPastDate && isLeavingDate
                    ? AppTheme.hintColor
                    : isSelected
                        ? AppTheme.bgColor
                        : isToday
                            ? AppTheme.primaryColor
                            : AppTheme.textColor,
              ),
            ),
          ),
        ),
      ),
    );

    // When a row reaches 7 days, start a new row
    if (currentRow.length == 7) {
      days.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.from(currentRow),
      ));
      currentRow.clear();
    }
  }

  // Fill remaining slots at the end of the last row
  while (currentRow.length < 7) {
    currentRow.add(const SizedBox(
      width: 35,
      height: 35,
    )); // Empty placeholders
  }
  days.add(Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: List.from(currentRow),
  ));

  return Column(children: days);
}
