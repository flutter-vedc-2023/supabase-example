import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventaris_app/services/item_service.dart';

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final description = TextEditingController();

  final picker = ImagePicker();
  final service = ItemService();

  XFile? photo;

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
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  picker.pickImage(source: ImageSource.camera).then(
                    (value) {
                      setState(() => photo = value);
                    },
                  ).catchError(
                    (err) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(err.toString())),
                      );
                    },
                  );
                },
                icon: const Icon(CupertinoIcons.camera),
                label: const Text("Tambah Foto"),
              ),
              const SizedBox(height: 12),
              photo != null ? Image.file(File(photo!.path), height: 300, width: 300, fit: BoxFit.cover) : Container(),
              Expanded(child: Container()),
              ElevatedButton(
                onPressed: () async {
                  // show dialog
                  if (_formKey.currentState!.validate() && photo != null) {
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

                    service.addItem(payload: {
                      'name': name.text,
                      'description': description.text,
                    }, imagePath: File(photo!.path)).then((value) {
                      Navigator.pop(context); // close dialog
                      Navigator.pop(context); // back to home
                    }).catchError((err) {
                      Navigator.pop(context); // close dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(err.toString())),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Inputannya Bos')),
                    );
                  }
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
