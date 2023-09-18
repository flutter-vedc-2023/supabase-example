import 'dart:io';

import 'package:inventaris_app/constant.dart';

class ItemService {
  Future<void> addItem({
    required Map<String, dynamic> payload,
    required File imagePath,
  }) async {
    final upload = await supabase.storage.from('vedc-inventaris').upload(imagePath.path.split('/').first, imagePath);
    // tutukno disini mas 
  }
}
