import 'package:supabase_flutter/supabase_flutter.dart';

class ProduitsOptions {
  static List<String> _listeProduits = [];
  static List<String> _listeTypes = ['Bouteille(s)', 'Paquet(s)'];
  static String? _selectedProduit;
  static String? _selectedType;
  static List<String> _listOptions = ['Mensuel', 'Hebdo', 'Annuel'];
  static String? _selectedOption;

  static String? get selectedProduit => _selectedProduit;
  static String? get selectedType => _selectedType;
  static String? get selectedOption => _selectedOption;

  static List<String> get listeProduits => _listeProduits;
  static List<String> get listeTypes => _listeTypes;
  static List<String> get listOptions => _listOptions;

  static void setSelectedProduit(String? value) {
    _selectedProduit = value;
  }

  static void setSelectedType(String? value) {
    _selectedType = value;
  }

  static void setSelectedOption(String? value) {
    _selectedOption = value;
  }

  // Fonction pour récupérer les produits depuis la table Supabase
  static Future<void> fetchProduits(SupabaseClient supabase) async {
    try {
      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        print(
            "Utilisateur non connecté. Impossible de récupérer les produits.");
        _listeProduits = [];
        return;
      }

      final response = await supabase.from('produits').select('nom_produit').eq(
          'utilisateur_id', currentUser.id); // Filtrer par utilisateur connecté

      if (response != null && response.isNotEmpty) {
        final produits =
            response.map((item) => item['nom_produit'].toString()).toList();
        _listeProduits = produits;
      } else {
        print('Aucun produit trouvé pour cet utilisateur.');
        _listeProduits = [];
      }
    } catch (e) {
      print('Erreur lors de la récupération des produits: $e');
      _listeProduits = [];
    }
  }
}
