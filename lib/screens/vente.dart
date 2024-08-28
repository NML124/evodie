import 'package:flutter/material.dart';
import 'package:gestion_depot/Constants/colors.dart';

class PageVentes extends StatefulWidget {
  const PageVentes({super.key});

  @override
  State<PageVentes> createState() => _PageVentesState();
}

class _PageVentesState extends State<PageVentes> {
  List<String> _options = ['Mensuel', 'Hebdomadaire', 'Annuel'];
  List<String> _listeProduits = [
    'Fiesta',
    'Zest',
    'American',
    'Africa fun',
    'Mirinda',
    'Pepsi'
  ];
  String? _selectedOption;
  String? _selectedProduit;

  @override

  ///
  /// This method returns a [Scaffold] widget that contains a [Column] widget
  /// with several child widgets. The [Column] widget contains a [ListTile]
  /// widget for displaying the owner's identity, a [Row] widget for displaying
  Widget build(BuildContext context) {
    /// selecting a product, and a [ListTile] widget for displaying the current
    /// sum and a dropdown button for selecting a payment frequency.
    return Scaffold(
      body: Column(
        children: [
          // identité du proprietaire
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
          // affichage de la ligne avec le text Vente
          const Row(
            children: <Widget>[
              Expanded(
                child: Divider(
                  color: ColorsConstant.black,
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'VENTE',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorsConstant.black,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: ColorsConstant.black,
                  thickness: 1,
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Produit:",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButtonFormField(
                items: _listeProduits.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _selectedProduit,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedProduit = newValue;
                  });
                },
                iconSize: 30,
                style: TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                ),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                hint: const Text(
                  "produit vendu",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                "Quantité:",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: null,
                  decoration: InputDecoration(
                    hintText: 'Quantité vendu',
                    hintStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 1),
                    ),
                  ),
                ),
              ),
              Container(
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
