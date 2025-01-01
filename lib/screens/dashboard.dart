import 'package:auto_size_text/auto_size_text.dart';
import 'package:evodie/Constants/colors.dart';
import 'package:evodie/Produits_Options/produits_options.dart';
import 'package:evodie/screens/dette.dart';
import 'package:evodie/widgets/customListTile.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

//import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  List<_SalesData> data = [
    _SalesData('Lun', 25),
    _SalesData('Mar', 30),
    _SalesData('Mer', 28),
    _SalesData('Jeu', 40),
    _SalesData('Ven', 40),
    _SalesData('Sam', 60),
    _SalesData('Dim', 55),
  ];

  final List<double> montants = [
    100,
    200,
    150,
    300,
    250,
    400
  ]; // Montants pour chaque jour
  final List<String> jours = [
    "Lun",
    "Mar",
    "Mer",
    "Jeu",
    "Ven",
    "Sam"
  ]; // Jours de la semaine

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 0,
            ),
            title: const AutoSizeText(
              "Somme actuelle",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            subtitle: const AutoSizeText(
              "20.000.000 Fc",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: ColorsConstant.green),
              maxLines: 1,
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey),
                borderRadius: BorderRadius.circular(15),
              ),
              child: DropdownButton(
                hint: const AutoSizeText(
                  'Type',
                  style: TextStyle(color: ColorsConstant.gray),
                  maxLines: 1,
                ),
                items: ProduitsOptions.listOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: AutoSizeText(
                      value,
                      style: TextStyle(color: ColorsConstant.black),
                      maxLines: 1,
                    ),
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
                iconSize: 30,
                style: TextStyle(fontSize: 18),
                underline: SizedBox(),
              ),
            ),
          ),
          // creation du graphique
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Expanded(
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(show: true), // Affiche les grilles
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                if (montants.contains(value)) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: TextStyle(fontSize: 12),
                                  );
                                }
                                return Container(); // Cache les valeurs non nécessaires
                              },
                              reservedSize: 40, // Taille de l'axe gauche
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 1, // Affiche un label tous les points
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();
                                if (index >= 0 && index < jours.length) {
                                  return Text(
                                    jours[index],
                                    style: TextStyle(fontSize: 12),
                                  );
                                }
                                return Container(); // Cache les valeurs hors plage
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false, // Cache les titres du haut
                            ),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false, // Cache les titres de droite
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(color: Colors.grey),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              montants.length,
                              (index) =>
                                  FlSpot(index.toDouble(), montants[index]),
                            ),
                            isCurved: true, // Ligne courbée
                            color: const Color.fromARGB(
                                255, 33, 150, 243), // Couleur de la ligne
                            dotData:
                                FlDotData(show: true), // Affiche les points
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withOpacity(
                                  0.3), // Remplissage sous la ligne
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  /* SfCartesianChart(
                      primaryXAxis: CategoryAxis(),
                      title: const ChartTitle(
                        text: 'Ventes de la semaine',
                      ),
                      legend: const Legend(isVisible: false),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<_SalesData, String>>[
                        LineSeries<_SalesData, String>(
                          dataSource: data,
                          xValueMapper: (_SalesData sales, _) => sales.day,
                          yValueMapper: (_SalesData sales, _) => sales.sales,
                          name: 'Ventes',
                          dataLabelSettings: DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ), */
                ],
              ),
            ),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomListTile(
                icon: Icons.arrow_drop_up_rounded,
                title: "12M Fc",
                subtitle: 'Bénéfice',
                colorTitle: ColorsConstant.green,
                colorSubtitle: ColorsConstant.gray,
              ),
              CustomListTile(
                icon: Icons.arrow_drop_down_rounded,
                title: "1.000 Fc",
                subtitle: "Perte",
                colorTitle: ColorsConstant.red,
                colorSubtitle: ColorsConstant.gray,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dette(),
                ),
              );
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomListTile(
                  icon: Icons.monetization_on_outlined,
                  title: "12M Fc",
                  subtitle: "Dette",
                  colorTitle: ColorsConstant.black,
                  colorSubtitle: ColorsConstant.gray,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            height: MediaQuery.of(context).size.height * 0.23,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey
                      .withOpacity(0.1), // Couleur de l'ombre avec une opacité
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
                  "Stock",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ColorsConstant.black),
                ),
                const Divider(
                  color: ColorsConstant.black,
                  thickness: 2,
                ),
                Container(
                  child: Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 0),
                          dense: true,
                          leading: const CircleAvatar(
                            radius: 20,
                            backgroundColor: ColorsConstant.green,
                          ),
                          title: Text(
                            "Produit ${index + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text("2 paquets restants"),
                          trailing: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("15.000.000 Fc"),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.arrow_drop_up_rounded,
                                    color: ColorsConstant.green,
                                  ),
                                  Text(
                                    "500 Fc",
                                    style:
                                        TextStyle(color: ColorsConstant.green),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(
                        color: ColorsConstant.black,
                        thickness: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SalesData {
  _SalesData(this.day, this.sales);

  final String day;
  final int sales;
}
