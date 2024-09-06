import 'package:evodie/Constants/colors.dart';
import 'package:evodie/Produits_Options/produits_options.dart';
import 'package:evodie/screens/dette.dart';
import 'package:evodie/widgets/customListTile.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
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
            title: const Text(
              "Somme actuelle",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text(
              "20.000.000 Fc",
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: ColorsConstant.green),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
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
                    child: SfCartesianChart(
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
                    ),
                  ),
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
