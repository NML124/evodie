import 'package:flutter/material.dart';

class MonEntreprise extends StatefulWidget {
  const MonEntreprise({super.key});

  @override
  State<MonEntreprise> createState() => _MonEntrepriseState();
}

class _MonEntrepriseState extends State<MonEntreprise> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Mon entreprise"),
      ),
    );
  }
}
