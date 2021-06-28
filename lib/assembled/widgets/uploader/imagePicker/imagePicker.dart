/// IMPORTING THIRD PARTY PACKAGES
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
    print("SI");
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

  /// The provider to handle any changes
  final ImagePickerState provider;

  PickImage({Key? key,
    required this.provider,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AvatarCircle(
          imagePath: this.provider.currentImage == null ? '' : this.provider.currentImage!.path,
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
                texts: [LocalizationClass.of(context).dynamicValue("changePic")],
                baseTextsType: [BaseTextType.normal],
                hasClick: [true],
                callBacksClick: [() => this.provider.getImage()],
              ),
            )
          ],
        )
      ],
    );
  }


}