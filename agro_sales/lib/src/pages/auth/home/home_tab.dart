import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agro_sales/src/models/item_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agro_sales/src/pages/auth/home/Components/filtered_items_grid.dart';
import 'package:agro_sales/src/pages/auth/home/Components/category_tile.dart';
import 'package:agro_sales/src/Screens/item_details_screen.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> categories = ['Todas', 'Gados Nelore', 'Gados Braford', 'Gados Brangus'];
  final TextEditingController searchController = TextEditingController();

  String selectedCategory = 'Todas';
  List<ItemModel> allItems = [];
  List<ItemModel> filteredItems = [];
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    fetchCurrentUser();
    fetchItems();
  }

  void fetchCurrentUser() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        currentUserId = user.uid;
      });
    }
  }

  void fetchItems() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('cattle')
          .where('isAvailable', isEqualTo: true)
          .get();

      final items = snapshot.docs.map((doc) => ItemModel.fromDocument(doc)).toList();

      setState(() {
        allItems = items;
        filteredItems = items;
      });
    } catch (error) {
      print('Erro ao buscar itens: $error');
    }
  }

  void filterItems() {
    setState(() {
      final query = searchController.text.toLowerCase();

      filteredItems = allItems.where((item) {
        final matchesCategory = selectedCategory == 'Todas' ||
            (selectedCategory == 'Gados Nelore' &&
                item.itemName?.toLowerCase().contains('nelore') == true) ||
            (selectedCategory == 'Gados Braford' &&
                item.itemName?.toLowerCase().contains('braford') == true) ||
            (selectedCategory == 'Gados Brangus' &&
                item.itemName?.toLowerCase().contains('brangus') == true);

        final matchesQuery =
            query.isEmpty || item.itemName?.toLowerCase().contains(query) == true;

        return matchesCategory && matchesQuery;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentUserId == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Usuário não autenticado. Faça login para continuar.',
            style: TextStyle(fontSize: 16, color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB52A2A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'AgroSales',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: searchController,
              onChanged: (value) => filterItems(),
              decoration: InputDecoration(
                hintText: 'Pesquisar...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          CategoriesList(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
              filterItems();
            },
          ),
          Expanded(
            child: FilteredItemsGrid(
              items: filteredItems,
              currentUserId: currentUserId!,
              onItemSelected: (item) async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ItemDetailsScreen(item: item),
                  ),
                );

                if (result == true) {
                  fetchItems();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
