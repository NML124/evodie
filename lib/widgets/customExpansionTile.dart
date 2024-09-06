import 'package:evodie/Constants/colors.dart';
import 'package:flutter/material.dart';

class CustomExpansionTile extends StatelessWidget {
  final String title;
  final String amount;
  final void Function()? onPressed;
  final List<ExpansionTileItem> items;

  const CustomExpansionTile({
    required this.onPressed,
    required this.title,
    required this.amount,
    required this.items,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 18,
                color: ColorsConstant.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        children: items.map((item) {
          return ListTile(
            title: Text(item.name),
            subtitle: Text('Prise le ${item.date}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  item.amount,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: onPressed,
                  icon: const Icon(
                    Icons.edit,
                    size: 25,
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ExpansionTileItem {
  final String name;
  final String amount;
  final String date;

  const ExpansionTileItem({
    required this.name,
    required this.amount,
    required this.date,
  });
}
