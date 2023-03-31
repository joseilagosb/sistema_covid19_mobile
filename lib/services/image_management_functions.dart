import 'package:image/image.dart' as image;
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class ImageManagementFunctions {
  static Future<ui.Image> getUiImage(String imageAssetPath, int height, int width) async {
    final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
    image.Image baseSizeImage =
        image.decodeImage(assetImageByteData.buffer.asUint8List()) ?? image.Image.empty();
    image.Image resizeImage = image.copyResize(baseSizeImage, height: height, width: width);
    ui.Codec codec = await ui.instantiateImageCodec(image.encodePng(resizeImage));
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return frameInfo.image;
  }
}
