import 'dart:math';

import 'package:emplify/core/database/employee_model.dart';
import 'package:emplify/data/repositories/employee_repository.dart';
import 'package:emplify/logic/employee/employee_bloc.dart';
import 'package:emplify/logic/employee/employee_event.dart';
import 'package:emplify/presentation/screens/employee_form_scaffold.dart';
import 'package:emplify/presentation/widgets/empty_list_ui.dart';
import 'package:emplify/utils/app_theme.dart';
import 'package:emplify/utils/constants.dart';
import 'package:emplify/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/employee/employee_state.dart';
import '../widgets/employee_list_widgets.dart';

class EmployeeListScaffold extends StatefulWidget {
  const EmployeeListScaffold({super.key});

  @override
  State<EmployeeListScaffold> createState() => _EmployeeListScaffoldState();
}

class _EmployeeListScaffoldState extends State<EmployeeListScaffold> {
  late EmployeeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<EmployeeBloc>(context);
    _bloc.add(FetchEmployeeList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgEmptyColor,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppTheme.primaryColor,
        title: const Text(
          Constants.employeeListTitle,
          style: TextStyle(
            color: AppTheme.bgColor,
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: BlocProvider(
          create: (context) =>
              _bloc..add(FetchEmployeeList()), // Fetch employees initially
          child: BlocBuilder<EmployeeBloc, EmployeeState>(
            buildWhen: (previous, current) =>
                previous.employeeList != current.employeeList,
            builder: (context, state) {
              if (state.employeeList.isNotEmpty) {
                final today = DateTime.now();
                final onlyDateToday =
                    DateTime(today.year, today.month, today.day);

                final currentEmployees = state.employeeList.where((e) {
                  if (e.leavingDate == null) return true;
                  final leavingDate = DateTime(e.leavingDate!.year,
                      e.leavingDate!.month, e.leavingDate!.day);
                  return leavingDate.isAfter(onlyDateToday) ||
                      leavingDate.isAtSameMomentAs(onlyDateToday);
                }).toList();

                final previousEmployees = state.employeeList.where((e) {
                  if (e.leavingDate == null) return false;
                  final leavingDate = DateTime(e.leavingDate!.year,
                      e.leavingDate!.month, e.leavingDate!.day);
                  return leavingDate.isBefore(onlyDateToday);
                }).toList();

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    children: [
                      /// Current Employees Header
                      if (currentEmployees.isNotEmpty)
                        buildHeader(Constants.currentEmployees),

                      /// Current Employees List
                      ...currentEmployees.map((employee) =>
                          buildDismissibleEmployee(
                              context, employee, currentEmployees, _bloc)),

                      /// Previous Employees Header
                      if (previousEmployees.isNotEmpty)
                        buildHeader(Constants.previousEmployees),

                      /// Current Employees List
                      ...previousEmployees.map((employee) =>
                          buildDismissibleEmployee(
                              context, employee, previousEmployees, _bloc)),
                    ],
                  ),
                );
              } else {
                return FutureBuilder(
                    future: Future.delayed(const Duration(seconds: 2)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primaryColor,
                          ), // Show loading spinner
                        );
                      }
                      if (state.employeeList.isEmpty) {
                        return const SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: EmptyListUi(),
                        );
                      }
                      _bloc.add(RefreshEmployeeData());
                      return const SizedBox.shrink();
                    });
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<EmployeeBloc, EmployeeState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: 100,
            color: AppTheme.bgEmptyColor,
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state.employeeList.isNotEmpty)
                    const Text(
                      Constants.swipeLeftToDelete,
                      style: TextStyle(
                        color: AppTheme.hintColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  if (state.employeeList.isEmpty) const Spacer(),
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: FloatingActionButton(
                      onPressed: () async {
                        var refresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmployeeFormScaffold(),
                          ),
                        );
                        if (refresh) {
                          context
                              .read<EmployeeBloc>()
                              .add(RefreshEmployeeData());
                        }
                      },
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: AppTheme.primaryColor,
                      child: const Icon(
                        Icons.add,
                        color: AppTheme.bgColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
