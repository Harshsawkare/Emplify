import 'package:flutter/material.dart';

import '../../core/database/employee_model.dart';

/// EmployeeFormState class to manage the state of the EmployeeForm widget
class EmployeeState {
  final TextEditingController employeeNameController;
  final TextEditingController employeeRoleController;
  final TextEditingController joiningDateController;
  final TextEditingController leavingDateController;
  List<Employee> employeeList;

  EmployeeState({
    required this.employeeNameController,
    required this.employeeRoleController,
    required this.joiningDateController,
    required this.leavingDateController,
    required this.employeeList,
  });

  EmployeeState copyWith({
    TextEditingController? employeeNameController,
    TextEditingController? employeeRoleController,
    TextEditingController? joiningDateController,
    TextEditingController? leavingDateController,
    List<Employee>? employeeList,
  }) {
    return EmployeeState(
      employeeNameController:
      employeeNameController ?? this.employeeNameController,
      employeeRoleController:
      employeeRoleController ?? this.employeeRoleController,
      joiningDateController:
      joiningDateController ?? this.joiningDateController,
      leavingDateController:
      leavingDateController ?? this.leavingDateController,
      employeeList: employeeList?? this.employeeList,
    );
  }
}
