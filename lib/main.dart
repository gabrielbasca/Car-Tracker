import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'car_insurance_service.dart';
import 'main_menu.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(
    ChangeNotifierProvider(
      create: (context) => CarInsuranceService(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vehicle Services',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Color(0xFF1A1A2E),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE94560)),
          bodyMedium: TextStyle(color: Color(0xFFE94560)),
        ),
      ),
      home: MainMenu(),
    );
  }
}
