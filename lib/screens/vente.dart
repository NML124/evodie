import 'package:auto_size_text/auto_size_text.dart';
import 'package:evodie/Constants/colors.dart';
import 'package:evodie/Produits_Options/produits_options.dart';
import 'package:evodie/widgets/customElevatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Vente extends StatefulWidget {
  const Vente({super.key});

  @override
  State<Vente> createState() => _VenteState();
}

class _VenteState extends State<Vente> {
  final SupabaseClient supabase = Supabase.instance.client;
  final TextEditingController _quantiteController = TextEditingController();
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _montantController = TextEditingController();

  bool isLoading = true;
  bool _isVisible = false;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    fetchProduits();
  }

  Future<void> fetchProduits() async {
    try {
      await ProduitsOptions.fetchProduits(supabase);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors de la récupération des produits: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> insertVente() async {
    try {
      setState(() {
        isSubmitting = true; // Commence le chargement
      });

      final currentUser = supabase.auth.currentUser;
      if (currentUser == null) {
        setState(() {
          isSubmitting =
              false; // Terminer le chargement si l'utilisateur n'est pas connecté
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text("Veuillez vous connecter avant d'enregistrer une vente."),
        ));
        return;
      }

      final String selectedProduit = ProduitsOptions.selectedProduit ?? '';
      final double quantiteVendu =
          double.tryParse(_quantiteController.text) ?? 0.0;
      final String selectedType = ProduitsOptions.selectedType ?? '';

      if (selectedProduit.isEmpty ||
          quantiteVendu <= 0 ||
          selectedType.isEmpty) {
        setState(() {
          isSubmitting =
              false; // Terminer le chargement si les champs sont invalides
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Veuillez remplir tous les champs obligatoires."),
        ));
        return;
      }

      final produitId = await getProduitId(selectedProduit, supabase);
      if (produitId == null) {
        setState(() {
          isSubmitting =
              false; // Terminer le chargement si le produit est introuvable
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Produit introuvable."),
        ));
        return;
      }

      int? detteId;
      if (_isVisible) {
        if (_nomController.text.isEmpty ||
            _prenomController.text.isEmpty ||
            (_montantController.text.isEmpty ||
                int.tryParse(_montantController.text) == null)) {
          setState(() {
            isSubmitting =
                false; // Terminer le chargement si les champs de la dette sont invalides
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Veuillez remplir tous les champs de la dette."),
          ));
          return;
        }

        final debtResponse = await supabase.from('dettes').insert({
          'produit_id': produitId,
          'nom_client': _nomController.text,
          'prenom_client': _prenomController.text,
          'montant_dette': int.tryParse(_montantController.text) ?? 0,
          'rembourse': false,
          'utilisateur_id': currentUser.id,
        }).select();

        if (debtResponse.isEmpty) {
          setState(() {
            isSubmitting =
                false; // Terminer le chargement si l'insertion de la dette échoue
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Erreur lors de l'enregistrement de la dette."),
          ));
          return;
        }

        detteId = debtResponse[0]['id'] as int?;
      }

      // Appel de la procédure stockée
      final response = await supabase.rpc('ajouter_vente', params: {
        'p_produit_id': produitId,
        'p_utilisateur_id': currentUser.id,
        'p_quantite_vendu': quantiteVendu,
        'p_type_vente': selectedType,
        'p_date_vente': DateTime.now().toIso8601String(),
        'p_dette_id': detteId,
        'p_id_vendeur': null,
      });

      if (response == null) {
        setState(() {
          isSubmitting =
              false; // Terminer le chargement lorsque l'insertion est réussie
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Vente enregistrée avec succès."),
        ));
        resetFields();
      } else {
        setState(() {
          isSubmitting = false; // Terminer le chargement en cas d'erreur
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Erreur lors de l'enregistrement de la vente."),
        ));
      }
    } catch (e) {
      setState(() {
        isSubmitting = false; // Terminer le chargement en cas d'exception
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur: $e"),
      ));
    }
  }

  Future<int?> getProduitId(String nomProduit, SupabaseClient supabase) async {
    final utilisateurId = supabase.auth.currentUser?.id;

    if (utilisateurId == null) {
      return null;
    }

    try {
      final response = await supabase
          .from('produits')
          .select('id')
          .eq('nom_produit', nomProduit)
          .eq('utilisateur_id', utilisateurId)
          .limit(1);

      if (response.isNotEmpty) {
        return response[0]['id'] as int?;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  void resetFields() {
    setState(() {
      _quantiteController.clear();
      _nomController.clear();
      _prenomController.clear();
      _montantController.clear();
      ProduitsOptions.setSelectedProduit(null);
      ProduitsOptions.setSelectedType(null);
      _isVisible = false;
    });
  }

  void showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Confirmer l'enregistrement"),
              content: isSubmitting
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height *
                          0.15, // Hauteur similaire au contenu précédent
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                ColorsConstant.green),
                          ),
                          SizedBox(height: 20),
                          Text("Traitement en cours..."),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            "Produit: ${ProduitsOptions.selectedProduit ?? 'N/A'}"),
                        Text("Quantité: ${_quantiteController.text}"),
                        Text("Type: ${ProduitsOptions.selectedType ?? 'N/A'}"),
                        if (_isVisible) ...[
                          const SizedBox(height: 10),
                          Text("Nom du débiteur: ${_nomController.text}"),
                          Text("Prénom du débiteur: ${_prenomController.text}"),
                          Text(
                              "Montant de la dette: ${_montantController.text}"),
                        ],
                      ],
                    ),
              actions: [
                TextButton(
                  onPressed: isSubmitting ? null : () => Navigator.pop(context),
                  child: const Text("Annuler"),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                          setDialogState(() {
                            isSubmitting = true; // Active le spinner
                          });

                          // Appelez la méthode insertVente()
                          await insertVente();

                          setDialogState(() {
                            isSubmitting = false; // Désactive le spinner
                          });

                          Navigator.pop(
                              context); // Ferme le dialogue après l'opération
                        },
                  child: isSubmitting
                      ? const Text("Traitement en cours...")
                      : const Text("Confirmer"),
                ),
              ],
            );
          },
        );
      },
      barrierDismissible:
          false, // Empêche de fermer le dialogue en cliquant en dehors
    );
  }

  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _quantiteController.dispose();
    _montantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // affichage de la ligne avec le texte Vente
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: ColorsConstant.black,
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: AutoSizeText(
                          'VENTE',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: ColorsConstant.black,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: ColorsConstant.black,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Affichage des produits
                  Row(
                    children: [
                      const AutoSizeText(
                        "Produit:",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DropdownButtonFormField(
                          items:
                              ProduitsOptions.listeProduits.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: AutoSizeText(
                                value,
                                style: TextStyle(color: ColorsConstant.black),
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                          value: ProduitsOptions.selectedProduit,
                          onChanged: (String? newValue) {
                            setState(() {
                              ProduitsOptions.setSelectedProduit(newValue);
                            });
                          },
                          iconSize: 30,
                          style: TextStyle(fontSize: 18),
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: Colors.black,
                          ),
                          hint: const AutoSizeText(
                            "Produit vendu",
                            style: TextStyle(color: Colors.grey),
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      const AutoSizeText(
                        "Quantité:",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: _quantiteController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Quantité vendue',
                            hintStyle: TextStyle(color: Colors.grey),
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 1),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          border: Border.all(width: 2, color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton(
                          hint: const AutoSizeText(
                            'Type',
                            maxLines: 1,
                          ),
                          items: ProduitsOptions.listeTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: AutoSizeText(
                                value,
                                style: const TextStyle(
                                  color: ColorsConstant.black,
                                ),
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                          value: ProduitsOptions.selectedType,
                          onChanged: (String? newValue) {
                            setState(() {
                              ProduitsOptions.setSelectedType(newValue);
                            });
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_down_sharp,
                          ),
                          iconSize: 30,
                          style: TextStyle(fontSize: 18),
                          underline: SizedBox(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  CheckboxListTile(
                    title: const AutoSizeText(
                      "Dette",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                    value: _isVisible,
                    onChanged: (bool? value) {
                      setState(() {
                        _isVisible = value!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const AutoSizeText(
                                "Nom:",
                                style: TextStyle(fontSize: 20),
                                maxLines: 1,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  controller: _nomController,
                                  decoration: const InputDecoration(
                                    hintText: 'Nom du débiteur',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const AutoSizeText(
                                "Prénom:",
                                style: TextStyle(fontSize: 20),
                                maxLines: 1,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  controller: _prenomController,
                                  decoration: const InputDecoration(
                                    hintText: 'Prénom du débiteur',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const AutoSizeText(
                                "Dette(franc):",
                                style: TextStyle(fontSize: 20),
                                maxLines: 1,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                flex: 1,
                                child: TextField(
                                  controller: _montantController,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: const InputDecoration(
                                    hintText: 'Montant de la dette',
                                    hintStyle: TextStyle(color: Colors.grey),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black, width: 1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomElevatedButton(
              buttonText: "Enregistrer",
              onPressed: showConfirmationDialog,
            ),
          ],
        ),
      ),
    );
  }
}
