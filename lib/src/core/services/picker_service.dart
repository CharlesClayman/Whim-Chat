import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

imagePicker(ImageSource source) async {
  final ImagePicker _picker = ImagePicker();
  XFile? imageFile = await _picker.pickImage(source: source);
  if (imageFile != null) return await imageFile.readAsBytes();
}
