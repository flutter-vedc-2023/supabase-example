import 'package:flutter/material.dart';
import 'package:inventaris_app/constant.dart';

class UpdateItemPage extends StatefulWidget {
  const UpdateItemPage({
    super.key,
    required this.name,
    required this.description,
    required this.id,
  });

  final String name;
  final String description;
  final int id;

  @override
  State<UpdateItemPage> createState() => _UpdateItemPageState();
}

class _UpdateItemPageState extends State<UpdateItemPage> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final description = TextEditingController();

  @override
  void initState() {
    super.initState();
    name.text = widget.name;
    description.text = widget.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: 0,
        title: const Text('Tambah Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // input name
              TextFormField(
                controller: name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter name';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Nama'),
              ),
              const SizedBox(height: 12),
              // input description
              TextFormField(
                controller: description,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter description';
                  }
                  return null;
                },
                decoration: const InputDecoration(hintText: 'Deskripsi'),
              ),
              Expanded(child: Container()),
              ElevatedButton(
                onPressed: () async {
                  // show dialog
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

                  supabase.from('items').update({
                    'name': name.text,
                    'description': description.text,
                  }).match({'id': widget.id}).then((value) {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // back to home
                  }).catchError((err) {
                    Navigator.pop(context); // close dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                  });
                },
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
