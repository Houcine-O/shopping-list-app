import 'package:flutter/material.dart';

import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/screens/new_item_screen.dart';
import 'package:shopping_list_app/widgets/grocery_list_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<GroceryItem> _groceryItems = [];
  void _addItemNavigation() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NewItemScreen()),
    );

    if (newItem == null) {
      return;
    } else {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(onPressed: _addItemNavigation, icon: const Icon(Icons.add))
        ],
      ),
      body: _groceryItems.isEmpty
          ? const Center(
              child: Text(
              'No items for the moment',
              style: TextStyle(
                fontSize: 22,
              ),
            ))
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (_, index) {
                return GroceryListItem(groceryListItem: _groceryItems[index]);
              }),
    );
  }
}
