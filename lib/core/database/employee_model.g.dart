// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeeAdapter extends TypeAdapter<Employee> {
  @override
  final int typeId = 0;

  @override
  Employee read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Employee(
      employeeId: fields[0] as String,
      employeeName: fields[1] as String,
      employeeRole: fields[2] as String,
      joiningDate: fields[3] as DateTime,
      leavingDate: fields[4] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Employee obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.employeeId)
      ..writeByte(1)
      ..write(obj.employeeName)
      ..writeByte(2)
      ..write(obj.employeeRole)
      ..writeByte(3)
      ..write(obj.joiningDate)
      ..writeByte(4)
      ..write(obj.leavingDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      employeeId: json['employeeId'] as String,
      employeeName: json['employeeName'] as String,
      employeeRole: json['employeeRole'] as String,
      joiningDate: DateTime.parse(json['joiningDate'] as String),
      leavingDate: json['leavingDate'] == null
          ? null
          : DateTime.parse(json['leavingDate'] as String),
    );

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'employeeRole': instance.employeeRole,
      'joiningDate': instance.joiningDate.toIso8601String(),
      'leavingDate': instance.leavingDate?.toIso8601String(),
    };
