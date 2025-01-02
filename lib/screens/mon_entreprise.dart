import 'package:evodie/utils/my_materials.dart';
import 'package:flutter/material.dart';

class MonEntreprise extends StatefulWidget {
  const MonEntreprise({super.key});

  @override
  State<MonEntreprise> createState() => _MonEntrepriseState();
}

class _MonEntrepriseState extends State<MonEntreprise> {
  final supabase = Supabase.instance.client;
  double capital_total = 0.0;
  double cout_employe = 0.0;
  double loye = 0.0;
  String adresse = "av. Kinvula/Kilimani/Kintambo/Kinshasa/RDC";

  String nom_entreprise = "nom de l'entreprise";
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    // final width = MediaQuery.sizeOf(context).width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Divider(
              color: ColorsConstant.green,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorsConstant.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: ColorsConstant.green,
                  child: Icon(
                    Icons.business,
                    size: 35,
                    color: ColorsConstant.white,
                  ),
                ),
                title: AutoSizeText(
                  nom_entreprise,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorsConstant.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AutoSizeText(
                        "Informations de l'entreprise:",
                        style: TextStyle(
                          color: ColorsConstant.green,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: height * 0.018,
                      ),
                      AutoSizeText(
                        "Capital total: $capital_total",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      AutoSizeText(
                        "Cout des employés: $cout_employe",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      AutoSizeText(
                        "Loyé: $loye",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      AutoSizeText(
                        "Adresse: $adresse",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorsConstant.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: const AutoSizeText(
                  "Mes produits",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MesProduits(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_right,
                    color: ColorsConstant.black,
                    size: 30,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorsConstant.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                title: const AutoSizeText(
                  "Mes employés",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.keyboard_arrow_right,
                    color: ColorsConstant.black,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
