import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list_app/data/categories.dart';

import 'package:shopping_list_app/models/grocery_item.dart';
import 'package:shopping_list_app/screens/new_item_screen.dart';
import 'package:shopping_list_app/widgets/grocery_list_item.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<GroceryItem> _groceryItems = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final url = Uri.https(
        'shopping-list-flutter-training-default-rtdb.firebaseio.com',
        'shopping-list.json');
    final List<GroceryItem> tempData = [];
    final response = await http.get(url);
    final Map<String, dynamic> itemsJson = json.decode(response.body);
    for (final item in itemsJson.entries) {
      final category = categories.entries
          .firstWhere((cat) => cat.value.name == item.value['category'])
          .value;
      tempData.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));
    }
    setState(() {
      _groceryItems = tempData;
    });
  }

  void _addItemNavigation() async {
    final returnItem = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NewItemScreen()),
    );

    setState(() {
      _groceryItems.add(returnItem);
    });
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
              'No items added yet',
              style: TextStyle(
                fontSize: 22,
              ),
            ))
          : ListView.builder(
              itemCount: _groceryItems.length,
              itemBuilder: (_, index) {
                return Dismissible(
                    onDismissed: (direction) {
                      setState(() {
                        _groceryItems.remove(_groceryItems[index]);
                      });
                    },
                    key: ValueKey(_groceryItems[index].id),
                    child:
                        GroceryListItem(groceryListItem: _groceryItems[index]));
              }),
    );
  }
}
