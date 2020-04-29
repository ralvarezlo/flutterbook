import 'package:image_picker/image_picker.dart';
import 'dart:io';

void getImageFromGallery() async {
  File image = await ImagePicker.pickImage(source: ImageSource.gallery);
}