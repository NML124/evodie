class ProduitsOptions {
  static const List<String> _listeProduits = [
    'Fiesta',
    'Zest',
    'American',
    'Africa fun',
    'Mirinda',
    'Pepsi'
  ];
  static List<String> _listeTypes = ['Bouteille(s)', 'Paquet(s)'];
  static List<String> _listOptions = ['Mensuel', 'Hebdomadaire', 'Annuel'];
  static String? _selectedProduit;
  static String? _selectedType;
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
}
