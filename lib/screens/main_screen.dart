import 'package:flutter/material.dart';

import 'package:shopping_list_app/data/dummy_items.dart';
import 'package:shopping_list_app/widgets/grocery_list_item.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
      ),
      body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (_, index) {
            return GroceryListItem(groceryListItem: groceryItems[index]);
          }),
    );
  }
}
