import 'package:evodie/Constants/colors.dart';
import 'package:evodie/Produits_Options/produits_options.dart';
import 'package:evodie/widgets/customElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Commande extends StatefulWidget {
  const Commande({super.key});

  @override
  State<Commande> createState() => _CommandeState();
}

class _CommandeState extends State<Commande> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              child: Column(
                children: [
                  const ListTile(
                    leading: CircleAvatar(
                      backgroundColor: ColorsConstant.green,
                    ),
                    title: Text(
                      "Jeanine Namwana",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      "Propriétaire",
                      style: TextStyle(fontSize: 15),
                    ),
                    trailing: Icon(
                      Icons.settings,
                    ),
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // identité du proprietaire

                        SizedBox(height: 20),
                        // affichage de la ligne avec le text Vente
                        const Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: ColorsConstant.black,
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                'COMMANDE',
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
                        SizedBox(height: 20),
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
                            SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField(
                                items: ProduitsOptions.listeProduits
                                    .map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: TextStyle(
                                        color: ColorsConstant.black,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                value: ProduitsOptions.selectedProduit,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    ProduitsOptions.setSelectedProduit(
                                        newValue);
                                  });
                                },
                                iconSize: 30,
                                style: TextStyle(fontSize: 18),
                                decoration: const InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_sharp,
                                  color: Colors.black,
                                ),
                                hint: const Text(
                                  "produit commandé",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            const Text(
                              "Prix(franc):",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  hintText: 'Prix de la commande',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
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
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  hintText: 'Quantité de paquet commandé',
                                  hintStyle: TextStyle(color: Colors.grey),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.black, width: 1),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomElevatedButton(buttonText: "Enregistrer", onPressed: () {})
          ],
        ),
      ),
    );
  }
}
