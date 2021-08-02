/// IMPORTING THE THIRD PARTY LIBRARIES
import 'dart:core';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// This is a component to render a custom asset from local or network path
class ZwapAsset extends StatelessWidget{

  /// The asset path of the custom image displayed in the icon
  final String? assetPathUrl;

  /// The image file to display inside this component
  final XFile? imageFile;

  /// Is the icon an internal asset
  final bool? isInternal;

  /// The final width of the image inside this custom icon. Default = 52
  final double imageWidth;

  /// The final height of the image inside this custom icon. Default = 52
  final double imageHeight;

  ZwapAsset({Key? key,
    this.assetPathUrl,
    this.imageFile,
    this.isInternal = false,
    this.imageHeight = 52,
    this.imageWidth = 52,
  }) : super(key: key);

  /// It returns local image asset
  Image _localImageAsset(){
    return Image.asset(this.assetPathUrl!,
      width: this.imageWidth,
      height: this.imageHeight,
    );
  }
  
  /// It returns external image asset
  Image _externalImageAsset(){
    return Image.network(
      this.assetPathUrl!,
      width: this.imageWidth,
      height: this.imageHeight,
    );
  }

  Widget _getFile(){
    return !kIsWeb ?
    Image.file(
      File(this.imageFile!.path),
      width: this.imageWidth,
      height: this.imageHeight,
    ) : Image.network(
      this.imageFile!.path,
      width: this.imageWidth,
      height: this.imageHeight,
    );

  }

  @override
  Widget build(BuildContext context) {
    return this.imageFile != null ? this._getFile() : (this.isInternal == null || !this.isInternal! ? this._externalImageAsset() : this._localImageAsset() );
  }

}