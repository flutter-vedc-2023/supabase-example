import 'package:flutter/material.dart';
import 'package:inventaris_app/components/custom_progress.dart';

class VerticalPage extends StatelessWidget {
  const VerticalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0, toolbarHeight: 0),
      body: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 300,
              child: CustomProgress(
                thumbColor: Colors.red,
                thumbSize: 50,
              ),
            ),
          )
        ],
      ),
    );
  }
}
