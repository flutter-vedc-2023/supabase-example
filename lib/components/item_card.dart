import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inventaris_app/constant.dart';
import 'package:inventaris_app/pages/item/update_item_page.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    this.name,
    this.description,
    required this.id,
  });

  final String? name;
  final String? description;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(offset: const Offset(2, 2), color: Colors.grey[200]!),
        ],
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.doc),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name ?? '-'),
              Text(description ?? '-'),
            ],
          ),
          Expanded(child: Container()),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (builder) => UpdateItemPage(
                    description: description ?? '-',
                    name: name ?? '-',
                    id: id,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false, // Prevent user from dismissing the dialog
                builder: (BuildContext context) {
                  return const AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircularProgressIndicator.adaptive(), // Circular Progress Indicator
                        SizedBox(height: 16.0),
                        Text('Loading...'),
                      ],
                    ),
                  );
                },
              );

              // DELETE FROM items WHERE id = 1;

              supabase.from('items').delete().match({'id': id}).then((value) {
                Navigator.pop(context); // close dialog
              }).catchError((err) {
                Navigator.pop(context); // close dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              });
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
    );
  }
}
