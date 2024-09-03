import 'package:evodie/Constants/colors.dart';
import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  // Constructeur pour passer le texte et la fonction
  CustomElevatedButton({required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Appelle la fonction passée en paramètre
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorsConstant.green, // Couleur de fond
        foregroundColor: ColorsConstant.white, // Couleur du texte
        padding: EdgeInsets.symmetric(
            horizontal: 25, vertical: 18), // Padding du bouton
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Coins arrondis
        ),
      ),
      child: Text(
        buttonText, // Texte du bouton
        style: TextStyle(fontSize: 23), // Style du texte
      ),
    );
  }
}
