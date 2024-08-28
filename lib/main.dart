import 'package:flutter/material.dart';
import 'package:gestion_depot/Constants/colors.dart';
import 'package:gestion_depot/screens/vente.dart';

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
      home: PageVentes(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Color green = Color.fromARGB(255, 0, 155, 140);
  List<String> _options = ['Mensuel', 'Hebdomadaire', 'Annuel'];
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: ColorsConstant.green,
            ),
            title: const Text(
              "Jeanine Namwana",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "Propriétaire",
              style: TextStyle(fontSize: 15),
            ),
            trailing: const Icon(
              Icons.settings,
            ),
          ),
          ListTile(
            title: Text(
              "Somme actuelle",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "20.000.000 Fc",
              style: TextStyle(
                  fontSize: 30, fontWeight: FontWeight.bold, color: green),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton(
                items: _options.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedOption = newValue;
                  });
                },
                iconSize: 30,
                style: TextStyle(fontSize: 18),
                underline: SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
