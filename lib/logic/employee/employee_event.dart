import 'package:flutter/material.dart';

import '../../core/database/employee_model.dart';


// Define an event class hierarchy for handling UI events related to employee data
abstract class EmployeeEvent {}

// Define UI events for the default employee form
class InitializeForm extends EmployeeEvent {}

// Define UI events for updating form fields
class UpdateFormField extends EmployeeEvent {
  final String field;
  final String value;

  UpdateFormField({required this.field, required this.value});
}

// Define UI events for fetching employee data
class FetchEmployeeList extends EmployeeEvent {}

// Define UI events for adding or updating employee data
class AddOrUpdateEmployeeData extends EmployeeEvent {
  final Employee employee;
  final BuildContext context;

  AddOrUpdateEmployeeData({required this.employee, required this.context});
}

// Define UI events for restoring employee data after delete
class RestoreEmployeeData extends EmployeeEvent {
  final Employee employee;
  final int index;

  RestoreEmployeeData({required this.employee, required this.index});
}

// Define UI events for deleting employee data
class DeleteEmployeeData extends EmployeeEvent {
  final Employee employee;

  DeleteEmployeeData({required this.employee});
}

// Define UI events for refreshing employee data
class RefreshEmployeeData extends EmployeeEvent {}

