import 'package:auto_size_text/auto_size_text.dart';
import 'package:evodie/Constants/colors.dart';
import 'package:evodie/Produits_Options/produits_options.dart';
import 'package:evodie/screens/dette.dart';
import 'package:evodie/utils/my_materials.dart';
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

  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> produits = [];
  double totalSomme = 0;
  double totalBenefice = 0;
  double totalPerte = 0;
  double totalDette = 0;
  String selectedPeriod = "hebdo";
  final List<String> periodOptions = ["hebdo", "mensuel", "annuel"];
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  late String userId;

  @override
  void initState() {
    super.initState();
    _fetchData();
    _fetchUserId();
  }

  Future<void> _fetchUserId() async {
    final session = supabase.auth.currentSession;
    if (session != null) {
      userId = session.user.id;
      await _fetchProducts();
    } else {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await supabase
          .from('produits')
          .select()
          .eq('utilisateur_id', userId)
          .order('date_ajout', ascending: false);

      setState(() {
        products = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors du chargement des produits: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchData() async {
    try {
      // Récupération des produits disponibles pour l'utilisateur connecté
      final userId = supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('Utilisateur non connecté');
      }

      final produitsResponse =
          await supabase.from('produits').select().eq('utilisateur_id', userId);

      final detteResponse = await supabase
          .from('dettes')
          .select('montant_dette')
          .eq('utilisateur_id', userId);

      if (produitsResponse == null || detteResponse == null) {
        throw Exception(
            'Erreur dans la récupération des données depuis Supabase');
      }

      // Transformation des données récupérées
      final produitData = List<Map<String, dynamic>>.from(produitsResponse);
      final detteData = List<Map<String, dynamic>>.from(detteResponse);

      double somme = 0;
      double benefice = 0;
      double perte = 0;
      double dette = detteData.fold<double>(
        0,
        (sum, item) => sum + (item['montant_dette'] ?? 0),
      );

      for (final produit in produitData) {
        final stock = produit['stock'] ?? 0;
        final prixUnitaire = produit['prix_unitaire'] ?? 0;
        final pourcentageBenefice =
            (produit['pourcentage_benefice'] ?? 0) / 100;

        somme += stock * prixUnitaire;
        benefice += stock * prixUnitaire * pourcentageBenefice;
        // perte += stock * produit['prix_acquisition'] - stock * prixUnitaire;
      }

      // Mise à jour de l'état
      setState(() {
        produits = produitData;
        totalSomme = somme;
        totalBenefice = benefice;
        totalPerte = perte;
        totalDette = dette;
      });
    } catch (e) {
      debugPrint('Erreur lors de la récupération des données : $e');
    }
  }

  void _changePeriod(String? newPeriod) {
    if (newPeriod != null) {
      setState(() {
        selectedPeriod = newPeriod;
      });
      _fetchData(); // Recharge les données en fonction de la période sélectionnée
    }
  }

  String formatNumber(double number) {
    if (number >= 1e9) {
      return "${(number / 1e9).toStringAsFixed(1)}B"; // Milliards
    } else if (number >= 1e6) {
      return "${(number / 1e6).toStringAsFixed(1)}M"; // Millions
    } else if (number >= 1e3) {
      return "${(number / 1e3).toStringAsFixed(1)}K"; // Milliers
    } else {
      return number.toStringAsFixed(0); // Nombre normal
    }
  }

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
            subtitle: AutoSizeText(
              "$totalSomme Fc",
              style: const TextStyle(
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
                items: periodOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: AutoSizeText(
                      value,
                      style: const TextStyle(color: ColorsConstant.black),
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                value: selectedPeriod,
                onChanged: _changePeriod,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomListTile(
                icon: Icons.arrow_drop_up_rounded,
                title: "${formatNumber(totalBenefice)} Fc",
                subtitle: 'Bénéfice',
                colorTitle: ColorsConstant.green,
                colorSubtitle: ColorsConstant.gray,
              ),
              CustomListTile(
                icon: Icons.arrow_drop_down_rounded,
                title: "${formatNumber(totalPerte)} Fc",
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomListTile(
                  icon: Icons.monetization_on_outlined,
                  title: "${formatNumber(totalDette)} Fc",
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
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                            color: ColorsConstant.green,
                          ))
                        : ListView.separated(
                            shrinkWrap: true,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              return ListTile(
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 0),
                                dense: true,
                                leading: const CircleAvatar(
                                  radius: 20,
                                  backgroundColor: ColorsConstant.green,
                                ),
                                title: AutoSizeText(
                                  product["nom_produit"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                    "${product["stock"]} paquets restants"),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    AutoSizeText(
                                        "${product['stock'] * product['prix_unitaire']} Fc"),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.arrow_drop_up_rounded,
                                          color: ColorsConstant.green,
                                        ),
                                        AutoSizeText(
                                          "${formatNumber((product['stock'] * product['prix_unitaire']) / 100)} Fc",
                                          style: const TextStyle(
                                            color: ColorsConstant.green,
                                          ),
                                          maxLines: 1,
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
