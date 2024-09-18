import 'package:auto_size_text/auto_size_text.dart';
import 'package:evodie/Constants/colors.dart';
import 'package:evodie/Produits_Options/produits_options.dart';
import 'package:evodie/widgets/customElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Vente extends StatefulWidget {
  const Vente({super.key});

  @override
  State<Vente> createState() => _VenteState();
}

class _VenteState extends State<Vente> {
  bool isChecked = false;
  bool _isVisible = false;

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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AutoSizeText(
                          'VENTE',
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
                          items:
                              ProduitsOptions.listeProduits.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: AutoSizeText(
                                value,
                                style: TextStyle(color: ColorsConstant.black),
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                          value: ProduitsOptions.selectedProduit,
                          onChanged: (String? newValue) {
                            setState(() {
                              ProduitsOptions.setSelectedProduit(newValue);
                            });
                          },
                          iconSize: 30,
                          style: TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.black,
                          ),
                          hint: const AutoSizeText(
                            "produit vendu",
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
                            hintText: 'Quantité vendue',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          hint: const AutoSizeText(
                            'Type',
                            maxLines: 1,
                          ),
                          items: ProduitsOptions.listeTypes.map((String value) {
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
                          }).toList(),
                          value: ProduitsOptions.selectedType,
                          onChanged: (String? newValue) {
                            setState(() {
                              ProduitsOptions.setSelectedType(newValue);
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
                    ],
                  ),
                  SizedBox(height: 20),
                  CheckboxListTile(
                    title: const AutoSizeText(
                      "Dette",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    value: _isVisible,
                    onChanged: (bool? value) {
                      setState(() {
                        _isVisible = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              AutoSizeText(
                                "Nom:",
                                style: TextStyle(fontSize: 20),
                                maxLines: 1,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Nom du débiteur',
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
                          const Row(
                            children: [
                              AutoSizeText(
                                "Prénom:",
                                style: TextStyle(fontSize: 20),
                                maxLines: 1,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Prénom du débiteur',
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
                          Row(
                            children: [
                              const AutoSizeText(
                                "Dette(franc):",
                                style: TextStyle(fontSize: 20),
                                maxLines: 1,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'Montant de la dette',
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
                  ),
                ],
              ),
            ),
            CustomElevatedButton(
              buttonText: "Enregistrer",
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
