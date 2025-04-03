import 'package:emplify/core/database/employee_db.dart';
import 'package:emplify/core/database/employee_model.dart';
import 'package:emplify/logic/employee/employee_event.dart';
import 'package:emplify/logic/employee/employee_state.dart';
import 'package:emplify/utils/constants.dart';
import 'package:emplify/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/employee_repository.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final EmployeeRepository repository;

  EmployeeBloc()
      : repository = EmployeeRepository(),
        super(EmployeeState(
          employeeNameController: TextEditingController(),
          employeeRoleController: TextEditingController(),
          joiningDateController: TextEditingController(),
          leavingDateController: TextEditingController(),
          employeeList: [],
        )) {
    on<InitializeForm>((event, emit) => _updateFormForAddScreen(emit));
    on<UpdateFormField>((event, emit) => _updateFormFieldData(event, emit));
    on<FetchEmployeeList>((event, emit) => _fetchData(emit));
    on<AddOrUpdateEmployeeData>(
        (event, emit) async => await _addOrUpdateData(event));
    on<DeleteEmployeeData>(
        (event, emit) async => await _deleteData(event, emit));
    on<RestoreEmployeeData>(
        (event, emit) async => await _restoreData(event, emit));
    on<RefreshEmployeeData>((event, emit) async => await _refreshData(emit));
  }

  // Reset employee fields in the form for adding a new employee
  void _updateFormForAddScreen(Emitter<EmployeeState> emit) {
    state.employeeNameController.text = '';
    state.employeeRoleController.text = '';
    state.joiningDateController.text = Constants.today;
    state.leavingDateController.text = '';
    emit(state);
  }

  // Update the specific field in the form based on the received event
  void _updateFormFieldData(
      UpdateFormField event, Emitter<EmployeeState> emit) {
    switch (event.field) {
      case Constants.employeeName:
        state.employeeNameController.text = event.value;
        break;
      case Constants.selectRole:
        state.employeeRoleController.text = event.value;
        break;
      case Constants.joiningDate:
        state.joiningDateController.text = event.value;
        break;
      case Constants.leavingDate:
        state.leavingDateController.text = event.value;
        break;
    }
    emit(state.copyWith());
  }

  // Fetch the employee list from the database and update the state
  void _fetchData(Emitter<EmployeeState> emit) {
    state.employeeList = repository.fetchEmployees();
    state.employeeList.forEach((employee) {
      print(employee);
    });
    emit(state.copyWith(employeeList: state.employeeList));
  }

  // Add or update the employee in the database and close the form
  Future<void> _addOrUpdateData(AddOrUpdateEmployeeData event) async {
    var response = await repository.addOrUpdateEmployeeInDB(event.employee);
    if (response) {
      Navigator.pop(event.context, true);
    }
  }

  // Delete the employee from the database and update the employee list
  Future<void> _deleteData(
      DeleteEmployeeData event, Emitter<EmployeeState> emit) async {
    await repository.deleteEmployeeInDB(event.employee.employeeId);
    var updatedList = await repository.fetchRecordsFromDB();
    emit(state.copyWith(employeeList: updatedList));
  }

  // Refresh the employee list by fetching the updated records from the DB
  Future<void> _refreshData(Emitter<EmployeeState> emit) async {
    var updatedList = await repository.fetchRecordsFromDB();
    emit(state.copyWith(employeeList: List.from(updatedList)));
  }

  // Restore the original employee without modifying its ID
  Future<void> _restoreData(
      RestoreEmployeeData event, Emitter<EmployeeState> emit) async {
    // Restore the original employee without modifying its ID
    await repository.addOrUpdateEmployeeInDB(event.employee);

    // Fetch the updated employee list from the DB
    var updatedList = await repository.fetchRecordsFromDB();

    emit(state.copyWith(employeeList: updatedList));
  }

  @override
  Future<void> close() {
    // Dispose controllers when Bloc is closed
    state.employeeNameController.dispose();
    state.employeeRoleController.dispose();
    state.joiningDateController.dispose();
    state.leavingDateController.dispose();
    state.employeeList.clear();
    return super.close();
  }
}
