/// IMPORTING THIRD PARTY PACKAGES
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/zwap_design_system.dart';

/// The image picker state to change the pic
class ImagePickerState extends ChangeNotifier{

  /// The file for the image
  File? _image;

  /// The image picker instance
  final picker = ImagePicker();

  /// This functions pick the image from local storage
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
    notifyListeners();
  }

  /// It returns the current image choose
  File? get currentImage => _image;
}

/// Custom widget to display an image picker
class PickImage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    ImagePickerState instance = ImagePickerState();
    Utils.registerType<ImagePickerState>(instance);
    return Column(
      children: [
        ProviderCustomer<ImagePickerState>(
            childWidget: (ImagePickerState provider){
              return AvatarCircle(
                imagePath: provider.currentImage == null ? '' : provider.currentImage!.path,
              );
            }
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 2, left: 10),
              child: CustomIcon(
                callBackPressedFunction: () {  },
                icon: Icons.camera_alt,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10, left: 2),
              child: BaseText(
                textAlignment: Alignment.centerLeft,
                texts: [Utils.getIt<LocalizationClass>().dynamicValue("changePic")],
                baseTextsType: [BaseTextType.normal],
                hasClick: [true],
                callBacksClick: [() => Provider.of<ImagePickerState>(context, listen: false).getImage()],
              ),
            )
          ],
        )
      ],
    );
  }


}