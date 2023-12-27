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
  var _isLoading = true;
  String? _err;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final url = Uri.https(
        'shopping-list-flutter-training-default-rtdb.firebaseio.com',
        'shopping-list.json');
    try {
      final response = await http.get(url);
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final List<GroceryItem> tempData = [];
      final Map<String, dynamic> itemsJson = json.decode(response.body);

      if (response.statusCode >= 400) {
        setState(() {
          _err = 'Failed to fetch data, please try again later.';
        });
      }

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
        _isLoading = false;
      });
    } catch (expt) {
      _err = 'Something went wrong! please try again later.';
    }
  }

  void _removeItem(GroceryItem item) async {
    final index = _groceryItems.indexOf(item);
    setState(() {
      _groceryItems.remove(item);
    });

    final url = Uri.https(
        'shopping-list-flutter-training-default-rtdb.firebaseio.com',
        'shopping-list/${item.id}.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        _groceryItems.insert(index, item);
      });
    }
  }

  void _addItemNavigation() async {
    final newItem = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const NewItemScreen()),
    );

    if (newItem == null) {
      return;
    }

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(
        child: Text(
      'No items added yet',
      style: TextStyle(
        fontSize: 22,
      ),
    ));

    if (_isLoading) {
      content = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_groceryItems.isNotEmpty) {
      content = ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (_, index) {
            return Dismissible(
                onDismissed: (direction) => _removeItem(_groceryItems[index]),
                key: ValueKey(_groceryItems[index].id),
                child: GroceryListItem(groceryListItem: _groceryItems[index]));
          });
    }

    if (_err != null) {
      content = Center(child: Text(_err!));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(onPressed: _addItemNavigation, icon: const Icon(Icons.add))
        ],
      ),
      body: content,
    );
  }
}
