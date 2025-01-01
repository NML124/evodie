import 'package:auto_size_text/auto_size_text.dart';
import 'package:evodie/Constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoriquePage extends StatefulWidget {
  const HistoriquePage({super.key});

  @override
  State<HistoriquePage> createState() => _HistoriquePageState();
}

class _HistoriquePageState extends State<HistoriquePage> {
  int _selectedIndex = 0;

  final List<String> _items = ['COMMANDE', 'LIVRAISON'];
  List<Map<String, Object?>> _ventes = [];
  List<Map<String, Object?>> _livraisons = [];
  bool _isLoading = true;
  String? _userId; // ID de l'utilisateur connecté

  @override
  void initState() {
    super.initState();
    _getUserIdAndFetchData();
  }

  Future<void> _getUserIdAndFetchData() async {
    try {
      // Récupérer l'utilisateur actuellement connecté
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        // Rediriger l'utilisateur vers la page de connexion si non connecté
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Veuillez vous connecter.")),
        );
        return;
      }

      setState(() {
        _userId = user.id;
      });

      // Charger les données de l'utilisateur connecté
      await _fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e')),
      );
    }
  }

  Future<void> _fetchData() async {
    try {
      setState(() => _isLoading = true);

      // Récupération des ventes de l'utilisateur connecté
      final ventesResponse = await Supabase.instance.client
          .from('ventes')
          .select('*, produits(nom_produit)')
          .eq('utilisateur_id', _userId!) // Filtrer par user_id
          .order('date_vente', ascending: false);

      // Récupération des livraisons de l'utilisateur connecté
      final livraisonsResponse = await Supabase.instance.client
          .from('commandes')
          .select('*, produits(nom_produit)')
          .eq('utilisateur_id', _userId!) // Filtrer par user_id
          .order('date_commande', ascending: false);

      setState(() {
        _ventes = List<Map<String, Object?>>.from(ventesResponse);
        _livraisons = List<Map<String, Object?>>.from(livraisonsResponse);
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText(
          'Historique',
          maxLines: 1,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: ColorsConstant.green,
        foregroundColor: ColorsConstant.white,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          children: [
            Container(
              width: width * 1,
              child: Row(
                children: List.generate(
                  _items.length,
                  (index) => GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.082,
                          child: const Divider(
                            thickness: 2,
                            color: ColorsConstant.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: AutoSizeText(
                            _items[index],
                            style: TextStyle(
                              fontSize: _selectedIndex == index ? 22 : 16,
                              fontWeight: _selectedIndex == index
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color: _selectedIndex == index
                                  ? Colors.black
                                  : Colors.grey,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          width: width * 0.082,
                          child: const Divider(
                            thickness: 2,
                            color: ColorsConstant.black,
                          ),
                        ),
                        /* if (_selectedIndex == index)
                          Container(
                            margin: EdgeInsets.only(top: 5),
                            height: 2,
                            width: 80,
                            color: Colors.black,
                          
                          ), */
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // _listHistorique[_selectedIndex],
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _selectedIndex == 0
                          ? _ventes.length
                          : _livraisons.length,
                      itemBuilder: (context, index) {
                        final data = _selectedIndex == 0
                            ? _ventes[index]
                            : _livraisons[index];

                        return ListTile(
                          title: Text(
                            _selectedIndex ==
                                    0 // Vérifie si on est dans les ventes
                                ? (data['produits'] is Map<String, Object?>
                                    ? (data['produits'] as Map<String,
                                                Object?>)['nom_produit']
                                            ?.toString() ??
                                        'Aucun produit'
                                    : 'Aucun produit')
                                : (data['produits'] is Map<String, Object?>
                                    ? (data['produits'] as Map<String,
                                                Object?>)['nom_produit']
                                            ?.toString() ??
                                        'Aucun produit'
                                    : 'Aucun produit'),
                          ),
                          subtitle: Text(
                            _selectedIndex == 0
                                ? (data['date_vente']?.toString() ??
                                    'Date inconnue')
                                : (data['date_commande']?.toString() ??
                                    'Date inconnue'), // Utilisation de date_commande pour les livraisons
                          ),
                          trailing: AutoSizeText(
                            _selectedIndex == 0
                                ? (data['quantite_vendu']?.toString() ?? '0')
                                : (data['quantite_commande']?.toString() ??
                                    '0'), // Utilisation de quantite_livree pour les livraisons
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
