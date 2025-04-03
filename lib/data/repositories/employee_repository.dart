import 'package:emplify/core/database/employee_db.dart';
import 'package:emplify/core/database/employee_model.dart';

/// Repository for managing employee data.
class EmployeeRepository extends EmployeeDB{

  /// Initializes the database.
  Future<void> initializeDB() async {
    await init();
  }

  /// Fetches all records from the database.
  Future<List<Employee>> fetchRecordsFromDB() async => fetchEmployees();

  /// Adds or updates an employee in the database.
  Future<bool> addOrUpdateEmployeeInDB(Employee employee) async {
    return await addOrUpdateEmployee(employee);
  }

  /// Deletes an employee from the database.
  Future<bool> deleteEmployeeInDB(String id) async {
    return await deleteEmployee(id);
  }
}