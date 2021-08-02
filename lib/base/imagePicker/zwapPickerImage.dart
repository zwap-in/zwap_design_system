/// IMPORTING THIRD PARTY PACKAGES
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

/// IMPORTING LOCAL PACKAGES
import 'package:zwap_design_system/base/text/zwapText.dart';
import 'package:zwap_design_system/base/avatar/zwapAvatar.dart';
import 'package:zwap_design_system/base/media/media.dart';

/// The image picker state to change the pic
class ZwapImagePickerState extends ChangeNotifier{

  /// The file for the image
  XFile? _image;

  /// The image picker instance
  final picker = ImagePicker();

  /// This functions pick the image from local storage
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = XFile(pickedFile.path);
    }
    notifyListeners();
  }

  /// It returns the current image choose
  XFile? get currentImage => _image;
}

/// Custom widget to display an image picker
class ZwapPickerImage extends StatelessWidget{

  /// The text label inside this image picker
  final String textLabel;

  ZwapPickerImage({Key? key,
    required this.textLabel
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<ZwapImagePickerState>(
          builder: (builder, provider, child){
            return ZwapAvatar(
                imagePath: provider.currentImage == null ? "" : null,
                isInternal: provider.currentImage == null,
                fileImage: provider.currentImage,
            );
          }
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 2, left: 10),
              child: ZwapIcon(
                callBackPressedFunction: () {  },
                icon: Icons.camera_alt,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10, left: 2),
              child: ZwapText(
                textAlignment: Alignment.centerLeft,
                texts: [this.textLabel],
                baseTextsType: [ZwapTextType.normalBold],
                hasClick: [true],
                callBacksClick: [() async => await context.read<ZwapImagePickerState>().getImage()],
              ),
            )
          ],
        )
      ],
    );
  }


}