import 'package:evodie/Constants/colors.dart';
import 'package:evodie/screens/homepage.dart';
import 'package:evodie/utils/my_materials.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final SupabaseClient supabase = Supabase.instance.client;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();

  bool _isLogin = true; // true pour login, false pour signup

  Future<void> _authenticate() async {
    try {
      final String email = _emailController.text;
      final String password = _passwordController.text;
      final String fullName = _fullNameController.text;

      if (_isLogin) {
        // Connexion
        final authResponse = await supabase.auth.signInWithPassword(
          email: email,
          password: password,
        );
        print('Connecté avec succès');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Connecté en tant que: ${authResponse.user!.email!}"),
        ));
      } else {
        // Inscription
        try {
          // Inscription de l'utilisateur
          final response = await supabase.auth.signUp(
            email: email,
            password: password,
          );

          // Vérification si l'utilisateur a bien été créé
          if (response.user != null) {
            final userId = response.user!.id;

            // Ajouter l'utilisateur dans la table `utilisateur`
            final insertResponse = await supabase.from('utilisateurs').insert({
              'id': userId, // L'ID de l'utilisateur Supabase
              'email': email,
              'nom_utilisateur': fullName,
              'password': password,
              // Ajoutez d'autres colonnes selon votre schéma
            }).select();

            if (insertResponse.isNotEmpty) {
              print('Utilisateur ajouté à la table utilisateur avec succès');
              print('Inscription réussie, veuillez vérifier votre email');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Inscrit en tant que: ${response.user!.email!}"),
              ));
            } else {
              print('Erreur lors de l\'ajout dans la table utilisateur');
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("Erreur lors de l'ajout dans la table utilisateur"),
              ));
            }
          }
        } catch (e) {
          print('Erreur lors de l\'inscription: $e');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Erreur lors de l'inscription: $e"),
          ));
        }
      }
    } catch (e) {
      print('Erreur: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Erreur: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          _isLogin ? 'Connexion' : 'Inscription',
          style: const TextStyle(
              color: ColorsConstant.green, fontWeight: FontWeight.bold),
          maxLines: 1,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: !_isLogin,
              child: TextField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: 'Nom complet'),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: CustomElevatedButton(
                onPressed: _authenticate,
                buttonText: _isLogin ? 'Se connecter' : 'S\'inscrire',
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(
                _isLogin ? 'Créer un compte' : "J'ai déjà un compte !",
                style: const TextStyle(color: ColorsConstant.green),
              ),
            ),
            /* ElevatedButton(
              onPressed: () => signInWithProvider('google'),
              child: const Text('Se connecter avec Google'),
            ) */
          ],
        ),
      ),
    );
  }
}
