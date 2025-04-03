import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:emplify/utils/constants.dart';
import 'employee_model.dart';

/// A simple adapter for the Employee model
abstract class EmployeeDB {
  static const String _boxName = Constants.dbName;
  static Box<Employee>? _box;

  // Initialize the box
  Future<void> init() async {
    if (!Hive.isAdapterRegistered(EmployeeAdapter().typeId)) {
      Hive.registerAdapter(EmployeeAdapter());
    }
    _box = await Hive.openBox<Employee>(_boxName);
  }

  // Get the box for storing employees
  static Box<Employee> get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception("Hive box is not open. Call init() first.");
    }
    return _box!;
  }

  // Fetch all employees from the box
  List<Employee> fetchEmployees() {
    try {
      var list = box.values.toList();
      list.forEach((employee) {
        print(employee.toJson());
      });
      return box.values.toList();
    } catch (e) {
      return []; // Return an empty list if an error occurs
    }
  }

  // Add or update an employee in the box
  Future<bool> addOrUpdateEmployee(Employee employee) async {
    try {
      await box.put(employee.employeeId, employee);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Delete an employee from the box
  Future<bool> deleteEmployee(String employeeId) async {
    try {
      await box.delete(employeeId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
