class Constants {
  /// DB constants
  static const String dbName = 'employee_db';

  /// Form constants
  static const String employeeName = 'Employee name';
  static const String selectRole = 'Select role';
  static const String joiningDate = 'Joining date';
  static const String leavingDate = 'Leaving date';

  /// Screen title constants
  static const String employeeListTitle = 'Employee List';
  static const String addEmployeeDetailsTitle = 'Add Employee Details';
  static const String editEmployeeDetailsTitle = 'Edit Employee Details';

  /// Screen titles
  static const String currentEmployees = 'Current employees';
  static const String previousEmployees = 'Previous employees';
  static const String swipeLeftToDelete = 'Swipe left to delete';

  /// Message constants
  static const String deletedMessage = 'Employee data has been deleted';
  static const String noRecordsMessage = 'No employee records found';
  static const String emptyNameMessage = 'Employee name cannot be empty';
  static const String emptyRoleMessage = 'Employee role cannot be empty';

  /// Button constants
  static const String undo = 'Undo';
  static const String save = 'Save';
  static const String cancel = 'Cancel';

  /// Date picker constants
  static const String noDate = 'No date';
  static const String today = 'Today';
  static const String nextMonday = 'Next Monday';
  static const String nextTuesday = 'Next Tuesday';
  static const String after1Week = 'After 1 week';

  /// Employee role constants
  static const String productDesigner = 'Product Designer';
  static const String flutterDeveloper = 'Flutter Developer';
  static const String qaTester = 'OA Tester';
  static const String productOwner = 'Product Owner';
  static const List<String> roles = [productDesigner, flutterDeveloper, qaTester, productOwner];

  /// Image/Icon paths
  static const String emptyListImagePath = 'assets/images/emptyList.png';
  static const String employeeIconPath = 'assets/icons/employee.png';
  static const String briefcaseIconPath = 'assets/icons/briefcase.png';
  static const String calenderIconPath = 'assets/icons/calender.png';
  static const String dropdownIconPath = 'assets/icons/dropdown.png';
  static const String rightArrowIconPath = 'assets/icons/right_arrow.png';
  static const String deleteIconPath = 'assets/icons/delete.png';
}