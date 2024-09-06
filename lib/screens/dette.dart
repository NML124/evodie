import 'package:evodie/widgets/customExpansionTile.dart';
import 'package:flutter/material.dart';
import 'package:evodie/Constants/colors.dart';
import 'package:evodie/Produits_Options/produits_options.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dette extends StatefulWidget {
  const Dette({super.key});

  @override
  State<Dette> createState() => _DetteState();
}

class _DetteState extends State<Dette> {
  List<_SalesData> data = [
    _SalesData('Lun', 25),
    _SalesData('Mar', 30),
    _SalesData('Mer', 28),
    _SalesData('Jeu', 40),
    _SalesData('Ven', 40),
    _SalesData('Sam', 60),
    _SalesData('Dim', 55),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'Dette',
                  style: TextStyle(
                      color: ColorsConstant.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(
              color: ColorsConstant.black,
              thickness: 2,
            ),
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 0,
              ),
              title: const Text(
                "Dette totale",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "12.080.000 Fc",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: ColorsConstant.green),
              ),
              trailing: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.grey),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButton(
                  hint: const Text(
                    'Type',
                    style: TextStyle(color: ColorsConstant.gray),
                  ),
                  items: ProduitsOptions.listOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(color: ColorsConstant.black)),
                    );
                  }).toList(),
                  value: ProduitsOptions.selectedOption,
                  onChanged: (String? newValue) {
                    setState(
                      () {
                        ProduitsOptions.setSelectedOption(newValue);
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down_sharp,
                  ),
                  iconSize: 25,
                  style: TextStyle(fontSize: 18),
                  underline: SizedBox(),
                ),
              ),
            ),
            // Correction du graphique
            Container(
              padding: EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.3,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: const ChartTitle(
                  text: 'Dettes de la semaine',
                ),
                legend: const Legend(isVisible: false),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<_SalesData, String>>[
                  LineSeries<_SalesData, String>(
                    dataSource: data,
                    xValueMapper: (_SalesData sales, _) => sales.day,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Dettes',
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.all(8),
              height: MediaQuery.of(context).size.height * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(
                        0.1), // Couleur de l'ombre avec une opacité
                    spreadRadius: 1, // La taille de l'ombre
                    blurRadius: 3, // L'intensité du flou de l'ombre
                    offset: const Offset(0,
                        -3), // Décalage de l'ombre : (0, -3) pour une ombre au-dessus
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Débiteurs",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: ColorsConstant.black),
                  ),
                  const Divider(
                    color: ColorsConstant.black,
                    thickness: 2,
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return CustomExpansionTile(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      backgroundColor: const Color(
                                          0xFFFFFDF9), // Couleur de fond (adaptée à l'image)
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Paiement dette',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Somme actuelle à payer : 70.000 Fc',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          const Text(
                                            'Paiement de :',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextField(
                                            decoration: InputDecoration(
                                              hintText: 'Somme payée',
                                              hintStyle: const TextStyle(
                                                color: Colors.grey,
                                              ),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Colors.grey.shade400),
                                              ),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                          const SizedBox(height: 20),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor:
                                                      ColorsConstant.white,
                                                  backgroundColor:
                                                      ColorsConstant.red,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text('Annuler'),
                                              ),
                                              const SizedBox(width: 10),
                                              ElevatedButton(
                                                onPressed: () {
                                                  // Logique de paiement ici
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor:
                                                      ColorsConstant.white,
                                                  backgroundColor:
                                                      ColorsConstant.green,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                child: const Text('Payer'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            title: 'Personne ${index + 1}',
                            amount: '12.000.000 Fc',
                            items: const [
                              ExpansionTileItem(
                                name: 'FIESTA',
                                amount: '70.000 Fc',
                                date: '12 septembre 2024',
                              ),
                              ExpansionTileItem(
                                name: 'Azzur',
                                amount: '10.000 Fc',
                                date: '10 octobre 2024',
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.day, this.sales);

  final String day;
  final int sales;
}
