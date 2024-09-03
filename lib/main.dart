import 'package:evodie/Constants/colors.dart';
import 'package:evodie/Produits_Options/produits_options.dart';
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
      home: Profile(),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ListTile(
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
            title: const Text(
              "Somme actuelle",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "20.000.000 Fc",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: ColorsConstant.green),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton(
                items: ProduitsOptions.listOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: ProduitsOptions.selectedOption,
                onChanged: (String? newValue) {
                  setState(() {
                    ProduitsOptions.setSelectedOption(newValue);
                  });
                },
                icon: const Icon(
                  Icons.keyboard_arrow_down_sharp,
                ),
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
