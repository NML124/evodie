import 'package:evodie/Constants/colors.dart';
import 'package:evodie/screens/dashboard.dart';
import 'package:evodie/screens/vente.dart';
import 'package:evodie/widgets/customElevatedButton.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 35,
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        'Profile',
                        style: TextStyle(
                            color: ColorsConstant.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(
              color: ColorsConstant.black,
              height: 3,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            const CircleAvatar(
              radius: 60,
              backgroundColor: ColorsConstant.green,
              foregroundColor: ColorsConstant.white,
              child: Icon(Icons.edit_outlined),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            const Row(
              children: [
                Text(
                  'Nom:',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Nom utilisateur',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      suffixIcon: Icon(Icons.edit_outlined),
                      suffixIconColor: ColorsConstant.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            const Row(
              children: [
                Text(
                  'Prénom:',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Prénom utilisateur',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      suffixIcon: Icon(Icons.edit_outlined),
                      suffixIconColor: ColorsConstant.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            const Row(
              children: [
                Text(
                  'Ancien mot de passe:',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Prénom utilisateur',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      suffixIcon: Icon(Icons.edit_outlined),
                      suffixIconColor: ColorsConstant.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.015,
            ),
            const Row(
              children: [
                Text(
                  'Nouveau mot de passe:',
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Prénom utilisateur',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                      suffixIcon: Icon(Icons.edit_outlined),
                      suffixIconColor: ColorsConstant.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            CustomElevatedButton(buttonText: 'SE DECONNECTER', onPressed: () {})
          ],
        ),
      ),
    );
  }
}
