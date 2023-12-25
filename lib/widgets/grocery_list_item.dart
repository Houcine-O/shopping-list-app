import 'package:flutter/material.dart';

import 'package:shopping_list_app/models/grocery_item.dart';

class GroceryListItem extends StatelessWidget {
  const GroceryListItem({super.key, required this.groceryListItem});

  final GroceryItem groceryListItem;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.square,
        color: groceryListItem.category.color,
      ),
      title: Text(groceryListItem.name),
      trailing: Text('${groceryListItem.quantity}'),
    );
  }
}
