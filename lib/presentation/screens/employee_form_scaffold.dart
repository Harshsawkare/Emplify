import 'package:emplify/core/database/employee_model.dart';
import 'package:emplify/logic/employee/employee_event.dart';
import 'package:emplify/presentation/widgets/app_button.dart';
import 'package:emplify/presentation/widgets/form_field.dart';
import 'package:emplify/utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_platform/universal_platform.dart';

import '../../logic/employee/employee_bloc.dart';
import '../../utils/app_theme.dart';
import '../../utils/constants.dart';

class EmployeeFormScaffold extends StatefulWidget {
  final Employee? employee;
  final int? index;
  const EmployeeFormScaffold({
    super.key,
    this.employee,
    this.index,
  });

  @override
  State<EmployeeFormScaffold> createState() => _EmployeeFormScaffoldState();
}

class _EmployeeFormScaffoldState extends State<EmployeeFormScaffold> {
  late EmployeeBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<EmployeeBloc>(context);
    if (widget.employee == null) {
      _bloc.add(InitializeForm());
    } else {
      _bloc.state.employeeNameController.text = widget.employee!.employeeName;
      _bloc.state.employeeRoleController.text = widget.employee!.employeeRole;

      DateTime joinedDate = widget.employee!.joiningDate;
      if (Helper.isCurrentDate(joinedDate)) {
        _bloc.state.joiningDateController.text = Constants.today;
      } else {
        _bloc.state.joiningDateController.text =
            Helper.formatDate(widget.employee!.joiningDate);
      }
      if (widget.employee!.leavingDate != null) {
        DateTime leavingDate = widget.employee!.leavingDate ?? DateTime.now();
        if (Helper.isCurrentDate(leavingDate)) {
          _bloc.state.leavingDateController.text = Constants.today;
        } else {
          _bloc.state.leavingDateController.text =
              Helper.formatDate(widget.employee!.leavingDate!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          widget.employee == null
              ? Constants.addEmployeeDetailsTitle
              : Constants.editEmployeeDetailsTitle,
          style: const TextStyle(
            color: AppTheme.bgColor,
          ),
        ),
        actions: [
          if (widget.employee != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: GestureDetector(
                onTap: () {
                  _bloc.add(DeleteEmployeeData(
                      employee: widget.employee!)); // Dispatch event to delete

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
                          _bloc.add(RestoreEmployeeData(
                            employee: widget.employee!,
                            index: widget.index!,
                          )); // Restore on undo
                        },
                      ),
                    ),
                  );

                  Navigator.pop(context, true);
                },
                child: Image.asset(
                  Constants.deleteIconPath,
                  height: 24,
                  fit: BoxFit.fill,
                ),
              ),
            ),
        ],
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          child: Column(
            children: [
              /// Employee Name Field
              AppFormField(
                controller: _bloc.state.employeeNameController,
                isTypeable: true,
                inputType: TextInputType.text,
                hintLabel: Constants.employeeName,
                prefixIcon: SizedBox(
                  width: 24,
                  height: 24,
                  child: Transform.scale(
                    scale: 0.6,
                    child: Image.asset(
                      Constants.employeeIconPath,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                callback: () {},
              ),

              /// Employee role Field
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: AppFormField(
                  controller: _bloc.state.employeeRoleController,
                  isTypeable: false,
                  hintLabel: Constants.selectRole,
                  prefixIcon: SizedBox(
                    width: 24,
                    height: 24,
                    child: Transform.scale(
                      scale: 0.6,
                      child: Image.asset(
                        Constants.briefcaseIconPath,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 20,
                    height: 20,
                    child: Transform.scale(
                      scale: 0.4,
                      child: Image.asset(
                        Constants.dropdownIconPath,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  callback: () => Helper.showEmployeeRoles(context, _bloc),
                ),
              ),

              /// Dates
              Row(
                children: [
                  /// Employee Joining Date Field
                  Expanded(
                    child: AppFormField(
                      controller: _bloc.state.joiningDateController,
                      isTypeable: false,
                      hintLabel: Constants.today,
                      prefixIcon: SizedBox(
                        width: 24,
                        height: 24,
                        child: Transform.scale(
                          scale: 0.6,
                          child: Image.asset(
                            Constants.calenderIconPath,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      callback: () {
                        final joining = Helper.parseDateFromFieldValues(
                            _bloc.state.joiningDateController.text);
                        Helper.showCustomDatePicker(
                          context,
                          Constants.joiningDate,
                          _bloc,
                          joining ?? DateTime.now(),
                          false,
                          joining ?? DateTime.now(),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Image.asset(
                      Constants.rightArrowIconPath,
                      height: 20,
                      fit: BoxFit.fill,
                    ),
                  ),

                  /// Employee Leaving Date Field
                  Expanded(
                    child: AppFormField(
                      controller: _bloc.state.leavingDateController,
                      isTypeable: false,
                      hintLabel: Constants.noDate,
                      prefixIcon: SizedBox(
                        width: 24,
                        height: 24,
                        child: Transform.scale(
                          scale: 0.6,
                          child: Image.asset(
                            Constants.calenderIconPath,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      callback: () {
                        final leaving = Helper.parseDateFromFieldValues(
                            _bloc.state.leavingDateController.text);
                        Helper.showCustomDatePicker(
                          context,
                          Constants.leavingDate,
                          _bloc,
                          leaving ?? DateTime.now(),
                          true,
                          Helper.parseDateFromFieldValues(
                                  _bloc.state.joiningDateController.text) ??
                              DateTime.now(),
                        );
                      },
                    ),
                  ),
                ],
              ),

              /// Buttons
              const Spacer(),
              Container(
                height: UniversalPlatform.isIOS ? 94 : 64,
                color: AppTheme.bgColor,
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
                            _bloc.add(InitializeForm());
                            Navigator.pop(context, true);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: AppButton(
                            label: Constants.save,
                            bgColor: AppTheme.primaryColor,
                            labelColor: AppTheme.bgColor,
                            onTap: () {
                              if (_bloc
                                  .state.employeeNameController.text.isEmpty) {
                                Helper.emptyFieldSnackBar(
                                  context,
                                  Constants.emptyNameMessage,
                                );
                              } else if (_bloc
                                  .state.employeeRoleController.text.isEmpty) {
                                Helper.emptyFieldSnackBar(
                                  context,
                                  Constants.emptyRoleMessage,
                                );
                              } else {
                                _bloc.add(
                                  AddOrUpdateEmployeeData(
                                    employee: Employee(
                                      employeeId: widget.employee == null
                                          ? Helper.generateRandomEmployeeId()
                                          : widget.employee!.employeeId,
                                      employeeName: _bloc
                                          .state.employeeNameController.text,
                                      employeeRole: _bloc
                                          .state.employeeRoleController.text,
                                      joiningDate: _bloc.state
                                                  .joiningDateController.text ==
                                              Constants.today
                                          ? DateTime.now()
                                          : Helper.convertToDateTime(_bloc
                                                  .state
                                                  .joiningDateController
                                                  .text) ??
                                              DateTime.now(),
                                      leavingDate: _bloc.state
                                                  .leavingDateController.text ==
                                              Constants.today
                                          ? DateTime.now()
                                          : Helper.convertToDateTime(_bloc.state
                                              .leavingDateController.text),
                                    ),
                                    context: context,
                                  ),
                                );
                                _bloc.add(FetchEmployeeList());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (UniversalPlatform.isIOS) const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
