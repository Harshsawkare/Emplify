import 'package:emplify/logic/employee/employee_bloc.dart';
import 'package:flutter/material.dart';

import '../../core/database/employee_model.dart';
import '../../logic/employee/employee_event.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';
import '../../utils/helper.dart';
import '../screens/employee_form_scaffold.dart';

/// Builds the section headers
Widget buildHeader(String title) {
  return Container(
    height: 56,
    width: double.infinity,
    alignment: Alignment.centerLeft,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
  );
}

/// Dismissible Employee Item
Widget buildDismissibleEmployee(
  BuildContext context,
  Employee employee,
  List<Employee> employees,
  EmployeeBloc bloc,
) {
  final index = employees.indexOf(employee);
  return Dismissible(
    key: Key(employee.employeeId),
    direction: DismissDirection.endToStart,
    background: Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 20),
      color: AppTheme.deleteColor,
      child: Image.asset(
        Constants.deleteIconPath,
        height: 24,
        fit: BoxFit.fill,
      ),
    ),
    onDismissed: (direction) {
      final removedEmployee = employee;

      bloc.add(
          DeleteEmployeeData(employee: employee)); // Dispatch event to delete

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            Constants.deletedMessage,
            style: TextStyle(
              color: AppTheme.bgColor,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
          duration: const Duration(seconds: 3),
          backgroundColor: AppTheme.textColor,
          action: SnackBarAction(
            label: Constants.undo,
            textColor: AppTheme.primaryColor,
            onPressed: () {
              bloc.add(RestoreEmployeeData(
                employee: removedEmployee,
                index: index,
              )); // Restore on undo
            },
          ),
        ),
      );
    },
    child: GestureDetector(
      onTap: () async {
        var refresh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EmployeeFormScaffold(
              employee: employee,
              index: index,
            ),
          ),
        );
        if (refresh != null && refresh) {
          bloc.add(RefreshEmployeeData());
        }
      },
      child: buildEmployeeTile(employee),
    ),
  );
}

/// Employee Tile UI
Widget buildEmployeeTile(Employee employee) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 0.5),
    child: Container(
      height: 104,
      width: double.infinity,
      color: AppTheme.bgColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              employee.employeeName,
              style: const TextStyle(
                color: AppTheme.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(
                employee.employeeRole,
                style: const TextStyle(
                  color: AppTheme.hintColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Text(
              employee.leavingDate == null
                  ? 'From ${Helper.formatDate(employee.joiningDate)}'
                  : '${Helper.formatDate(employee.joiningDate)} - ${Helper.formatDate(employee.leavingDate!)}',
              style: const TextStyle(
                color: AppTheme.hintColor,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
