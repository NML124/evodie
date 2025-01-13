import 'package:auto_size_text/auto_size_text.dart';
import 'package:evodie/widgets/customExpansionTile.dart';
import 'package:flutter/material.dart';
import 'package:evodie/Constants/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dette extends StatefulWidget {
  const Dette({super.key});

  @override
  State<Dette> createState() => _DetteState();
}

class _DetteState extends State<Dette> {
  List<Map<String, dynamic>> dettes = [];
  List<Map<String, dynamic>> produits = [];
  List<Map<String, dynamic>> filteredDettes = [];
  String? selectedType;

  final List<_SalesData> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      print('Utilisateur non connecté');
      return;
    }

    await fetchDettes(userId);
    await fetchProduits(userId);
  }

  void filterDettesByType() {
    setState(() {
      if (selectedType == null || selectedType!.isEmpty) {
        filteredDettes = List.from(dettes);
      } else {
        filteredDettes = dettes
            .where((dette) => dette['type_dette'] == selectedType)
            .toList();
      }
    });
  }

  Future<void> fetchDettes(String userId) async {
    try {
      final List<dynamic> response = await Supabase.instance.client
          .from('dettes')
          .select('*')
          .eq('utilisateur_id', userId);

      setState(() {
        dettes =
            response.map((dette) => Map<String, dynamic>.from(dette)).toList();
        chartData.clear();
        chartData.addAll(dettes.map((dette) => _SalesData(
              dette['date_dette'].toString(),
              dette['montant_dette'] as int,
            )));
      });
    } catch (e) {
      print('Erreur lors de la récupération des dettes : $e');
    }
  }

  Future<void> fetchProduits(String userId) async {
    try {
      final List<dynamic> response = await Supabase.instance.client
          .from('produits')
          .select('*')
          .eq('utilisateur_id', userId);

      setState(() {
        produits = response
            .map((produit) => Map<String, dynamic>.from(produit))
            .toList();
      });
    } catch (e) {
      print('Erreur lors de la récupération des produits : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.025),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 35,
                  ),
                ),
                const SizedBox(width: 10),
                const AutoSizeText(
                  'Dette',
                  style: TextStyle(
                    color: ColorsConstant.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ],
            ),
            const Divider(
              color: ColorsConstant.black,
              thickness: 2,
            ),
            ListTile(
              dense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              title: const AutoSizeText(
                "Dette totale",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                maxLines: 1,
              ),
              subtitle: AutoSizeText(
                "${dettes.fold<num>(0, (sum, dette) => sum + (dette['montant_dette'] ?? 0))} Fc",
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: ColorsConstant.green,
                ),
                maxLines: 1,
              ),
              trailing: DropdownButton<String>(
                hint: const AutoSizeText(
                  'Type',
                  style: TextStyle(color: ColorsConstant.gray),
                  maxLines: 1,
                ),
                items: produits.map((produit) {
                  return DropdownMenuItem<String>(
                    value: produit['nom_produit'],
                    child: AutoSizeText(
                      produit['nom_produit'] ?? '',
                      style: const TextStyle(color: ColorsConstant.black),
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                value: selectedType,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
                icon: const Icon(Icons.keyboard_arrow_down_sharp),
                iconSize: 25,
                style: const TextStyle(fontSize: 18),
                underline: const SizedBox(),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              height: MediaQuery.of(context).size.height * 0.3,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: const ChartTitle(text: 'Dettes de la semaine'),
                legend: const Legend(isVisible: false),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CartesianSeries<_SalesData, String>>[
                  LineSeries<_SalesData, String>(
                    dataSource: chartData,
                    xValueMapper: (_SalesData sales, _) => sales.day,
                    yValueMapper: (_SalesData sales, _) => sales.sales,
                    name: 'Dettes',
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
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
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AutoSizeText(
                    "Débiteurs",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorsConstant.black,
                    ),
                  ),
                  const Divider(color: ColorsConstant.black, thickness: 2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: dettes.length,
                      itemBuilder: (context, index) {
                        final dette = dettes[index];
                        return CustomExpansionTile(
                          title:
                              "${dette['nom_client']} ${dette['prenom_client']}",
                          amount: "${dette['montant_dette']} Fc",
                          items: produits.map((produit) {
                            return ExpansionTileItem(
                              name: produit['nom_produit'],
                              amount: "${produit['prix_unitaire']} Fc",
                              date: produit['date_ajout'].toString(),
                            );
                          }).toList(),
                          onPressed: () {},
                        );
                      },
                    ),
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
