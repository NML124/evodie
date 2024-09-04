import 'package:evodie/Constants/colors.dart';
import 'package:evodie/Produits_Options/produits_options.dart';
import 'package:evodie/screens/profile.dart';
import 'package:flutter/material.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class DashBoardPage extends StatefulWidget {
  const DashBoardPage({super.key, required this.title});

  final String title;

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> {
  /* List<_SalesData> data = [
    _SalesData('Lun', 25),
    _SalesData('Mar', 30),
    _SalesData('Mer', 35),
    _SalesData('Jeu', 40),
    _SalesData('Ven', 45),
    _SalesData('Sam', 50),
    _SalesData('Dim', 55),
  ]; */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
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
            trailing: GestureDetector.new(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Profile(),
                  ),
                );
              },
              child: const Icon(
                Icons.settings_outlined, // l'icône que vous voulez afficher
                size: 35,
                color: Colors.black, // couleur de l'icône
              ),
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
                hint: const Text(
                  'Type',
                  style: TextStyle(color: ColorsConstant.gray),
                ),
                items: ProduitsOptions.listOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
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
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.015,
          ),
          /* Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  title: ChartTitle(
                    text: 'Ventes de la semaine',
                  ),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries<_SalesData, String>>[
                    LineSeries<_SalesData, String>(
                      dataSource: data,
                      xValueMapper: (_SalesData sales, _) => sales.day,
                      yValueMapper: (_SalesData sales, _) => sales.sales,
                      name: 'Sales',
                      dataLabelSettings: DataLabelSettings(isVisible: true),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SfSparkAreaChart.custom(
                      trackball: SparkChartTrackball(
                          activationMode: SparkChartActivationMode.tap),
                      marker: SparkChartMarker(
                        displayMode: SparkChartMarkerDisplayMode.all,
                      ),
                      labelDisplayMode: SparkChartLabelDisplayMode.all,
                      xValueMapper: (int index) => data[index].day,
                      yValueMapper: (int index) => data[index].sales,
                      dataCount: 7,
                    ),
                  ),
                )
              ],
            ),
          ) */
        ],
      ),
    );
  }
}

/* class _SalesData {
  _SalesData(this.day, this.sales);

  final String day;
  final int sales;
} */
