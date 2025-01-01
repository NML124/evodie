import 'package:evodie/screens/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://lsprpollfbjpeigzpcgx.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxzcHJwb2xsZmJqcGVpZ3pwY2d4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjY3MzEwNDgsImV4cCI6MjA0MjMwNzA0OH0.AmqDMS5wOkyfhditZq6WMKVh-hFsQj_EkGQg1i4wcsw",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Gestion Depot",
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
