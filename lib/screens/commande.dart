import 'package:auto_size_text/auto_size_text.dart';
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
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              child: AutoSizeText(
                                'COMMANDE',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsConstant.black,
                                ),
                                maxLines: 1,
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
                            const AutoSizeText(
                              "Produit:",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: DropdownButtonFormField(
                                items: ProduitsOptions.listeProduits.map(
                                  (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: AutoSizeText(
                                        value,
                                        style: const TextStyle(
                                          color: ColorsConstant.black,
                                        ),
                                        maxLines: 1,
                                      ),
                                    );
                                  },
                                ).toList(),
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
                                hint: const AutoSizeText(
                                  "produit commandé",
                                  style: TextStyle(color: Colors.grey),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            const AutoSizeText(
                              "Prix(franc):",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
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
                            const AutoSizeText(
                              "Quantité:",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
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
            CustomElevatedButton(
              buttonText: "Enregistrer",
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
