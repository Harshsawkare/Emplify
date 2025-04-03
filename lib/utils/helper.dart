import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../logic/employee/employee_bloc.dart';
import '../logic/employee/employee_event.dart';
import '../presentation/widgets/app_button.dart';
import '../presentation/widgets/calender_widgets.dart';
import 'app_theme.dart';
import 'constants.dart';

class Helper {
  /// Generate random 4-digit employee ID.
  static String generateRandomEmployeeId() {
    const String chars = '0123456789abcdefghijklmnopqrstuvwxyz';
    Random random = Random();
    return List.generate(4, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  /// Generate date string in the format "5 Sept 2020".
  static String formatDate(DateTime date) {
    return DateFormat("d MMM y").format(date);
  }

  /// Generate DateTime from "5 Sept 2020" format.
  static DateTime? convertToDateTime(String dateString) {
    try {
      // Define the date format that matches the input string
      DateFormat format = DateFormat("d MMM yyyy");

      // Parse the string into a DateTime object
      return format.parse(dateString);
    } catch (e) {
      return null;
    }
  }

  // Parse date from the field values and return the DateTime object.
  static DateTime? parseDateFromFieldValues(String date) {
    return (date.isEmpty || date == Constants.today)
        ? DateTime.now()
        : Helper.convertToDateTime(date);
  }

  // Show custom date picker dialog.
  static void showCustomDatePicker(
    BuildContext context,
    String field,
    EmployeeBloc bloc,
    DateTime setDate,
    bool isLeavingDate,
    DateTime joiningDate,
  ) {
    DateTime selectedDate = setDate;
    DateTime selectedMonth = DateTime(selectedDate.year, selectedDate.month);
    PageController pageController = PageController(
        initialPage: selectedDate.year * 12 + selectedDate.month - 1);
    int selectedIndex = (DateTime.now().year == selectedDate.year &&
            DateTime.now().month == selectedDate.month &&
            DateTime.now().day == selectedDate.day)
        ? 0
        : -1; // Default selected index

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            List<String> options = [
              Constants.today,
              Constants.nextMonday,
              Constants.nextTuesday,
              Constants.after1Week,
            ];
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              backgroundColor: AppTheme.bgColor,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GridView.builder(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 16,
                      ),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 3.6,
                      ),
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        bool isSelected = selectedIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedIndex = index;
                              selectedDate = skipAndUpdateDate(
                                  selectedIndex, index, options, selectedDate);
                              int newPage = selectedDate.year * 12 +
                                  selectedDate.month -
                                  1;
                              selectedMonth = DateTime(
                                  selectedDate.year, selectedDate.month);
                              pageController.animateToPage(
                                newPage,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            });
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 30,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : AppTheme.secondaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              options[index],
                              style: TextStyle(
                                color: isSelected
                                    ? AppTheme.bgColor
                                    : AppTheme.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Header with Month and Navigation
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_left_rounded,
                              color:
                                  selectedMonth.year == DateTime.now().year &&
                                          selectedMonth.month ==
                                              DateTime.now().month
                                      ? AppTheme.borderColor
                                      : AppTheme.hintColor,
                              size: 40,
                            ),
                            onPressed: () {
                              if (!(selectedMonth.year == DateTime.now().year &&
                                  selectedMonth.month ==
                                      DateTime.now().month)) {
                                pageController.previousPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut);
                              }
                            },
                          ),
                          Text(
                            DateFormat('MMMM yyyy').format(selectedMonth),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textColor,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_right_rounded,
                              color: AppTheme.hintColor,
                              size: 40,
                            ),
                            onPressed: () {
                              pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut);
                            },
                          ),
                        ],
                      ),
                    ),

                    // Calendar Grid
                    Container(
                      height: 300,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (index) {
                          setState(() {
                            int newYear = index ~/ 12;
                            int newMonth = (index % 12) + 1;

                            // Keep the same day but ensure it's valid in the new month
                            int newDay = selectedDate.day;
                            int lastDayOfNewMonth =
                                DateTime(newYear, newMonth + 1, 0).day;

                            // If previous day exceeds the max day of new month, adjust it
                            if (newDay > lastDayOfNewMonth) {
                              newDay = lastDayOfNewMonth;
                            }

                            selectedMonth = DateTime(newYear, newMonth);
                          });
                        },
                        itemBuilder: (context, index) {
                          DateTime month =
                              DateTime(index ~/ 12, (index % 12) + 1, 1);
                          return buildCalendar(
                            month,
                            selectedDate,
                            (date) {
                              setState(() {
                                selectedDate = date;
                                selectedMonth = DateTime(
                                    selectedDate.year, selectedDate.month);
                              });
                            },
                            isLeavingDate,
                            joiningDate,
                          );
                        },
                      ),
                    ),

                    // Bottom Buttons
                    Container(
                      height: 72,
                      child: Column(
                        children: [
                          //Divider
                          const Divider(
                            height: 2,
                            color: AppTheme.bgEmptyColor,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppButton(
                                label: Constants.cancel,
                                bgColor: AppTheme.secondaryColor,
                                labelColor: AppTheme.primaryColor,
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: AppButton(
                                  label: Constants.save,
                                  bgColor: AppTheme.primaryColor,
                                  labelColor: AppTheme.bgColor,
                                  onTap: () {
                                    bloc.add(UpdateFormField(
                                      field: field,
                                      value: Helper.formatDate(selectedDate),
                                    ));
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Returns snack bar for empty fields
  static void emptyFieldSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: AppTheme.bgColor,
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppTheme.textColor,
      ),
    );
  }

  // Returns a bottom sheet with employee roles
  static void showEmployeeRoles(
      BuildContext context,
      EmployeeBloc bloc,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.bgColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return ListView.separated(
          itemCount: 4,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Center(
                  child: Text(
                    Constants.roles[index],
                    style: const TextStyle(
                      color: AppTheme.textColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  )),
              onTap: () {
                bloc.add(UpdateFormField(
                  field: Constants.selectRole,
                  value: Constants.roles[index],
                ));
                Navigator.pop(context);
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            height: 1,
            color: AppTheme.bgEmptyColor,
          ),
        );
      },
    );
  }
}
