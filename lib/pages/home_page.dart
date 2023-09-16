import 'package:flutter/material.dart';
import 'package:inventaris_app/components/item_card.dart';
import 'package:inventaris_app/constant.dart';
import 'package:inventaris_app/pages/item/add_item_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _stream = supabase.from('items').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text('List Barang'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<List<Map<String, dynamic>>>(
            stream: _stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: (snapshot.data ?? [])
                      .map(
                        (e) => ItemCard(
                          name: e['name'],
                          description: e['description'],
                          id: e['id'],
                        ),
                      )
                      .toList(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => const AddItemPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
