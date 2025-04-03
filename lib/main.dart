import 'package:emplify/logic/employee/employee_bloc.dart';
import 'package:emplify/logic/employee/employee_event.dart';
import 'package:emplify/presentation/screens/employee_list_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import 'data/repositories/employee_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await EmployeeRepository().initializeDB(); // Inject Repository

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (context) => EmployeeBloc()..add(InitializeForm())),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emplify',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const EmployeeListScaffold(),
    );
  }
}
