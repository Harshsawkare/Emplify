// employee_model.dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Employee {
  @HiveField(0)
  final String employeeId;

  @HiveField(1)
  final String employeeName;

  @HiveField(2)
  final String employeeRole;

  @HiveField(3)
  final DateTime joiningDate;

  @HiveField(4)
  final DateTime? leavingDate;

  Employee({
    required this.employeeId,
    required this.employeeName,
    required this.employeeRole,
    required this.joiningDate,
    this.leavingDate,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}