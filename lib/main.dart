import 'package:evodie/Constants/colors.dart';
import 'package:evodie/Produits_Options/produits_options.dart';
import 'package:evodie/screens/dashboard.dart';
import 'package:evodie/screens/profile.dart';
import 'package:evodie/screens/vente.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: DashBoardPage(title: 'Gestion Depot'),
    );
  }
}
