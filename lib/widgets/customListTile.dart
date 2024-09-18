import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color colorTitle;
  final Color colorSubtitle;
  const CustomListTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorTitle,
    required this.colorSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.075,
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color.fromARGB(255, 233, 233, 233),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          dense: true,
          leading: Icon(
            icon,
            color: colorTitle,
            size: 23,
          ),
          title: AutoSizeText(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: colorTitle,
            ),
            maxLines: 1,
          ),
          subtitle: AutoSizeText(
            subtitle,
            style: TextStyle(
              fontSize: 13,
              color: colorSubtitle,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ),
      ),
    );
  }
}
