import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_handson_edit_image/gen/assets.gen.dart';
import 'package:image/image.dart' as image_lib;

class ImageEditScreen extends StatefulWidget {
  const ImageEditScreen({super.key, required this.imageBitmap});

  final Uint8List imageBitmap;

  @override
  State<ImageEditScreen> createState() => _ImageEditScreenState();
}

class _ImageEditScreenState extends State<ImageEditScreen> {
  late Uint8List _imageBitmap;

  @override
  void initState() {
    super.initState();
    _imageBitmap = widget.imageBitmap;
  }

  void _rotateImage() {
    // 画像データをデコード
    final image = image_lib.decodeImage(_imageBitmap);
    if (image == null) return;

    final rotatedImage = image_lib.copyRotate(image, angle: 90);

    setState(() {
      _imageBitmap = image_lib.encodeBmp(rotatedImage);
    });
  }

  void _flipImage() {
    final image = image_lib.decodeImage(_imageBitmap);
    if (image == null) return;
    final flipedImage = image_lib.copyFlip(image,
        direction: image_lib.FlipDirection.horizontal);
    setState(() {
      _imageBitmap = image_lib.encodeBmp(flipedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.imageEditScreen),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.memory(_imageBitmap),
          IconButton(
            onPressed: () => _rotateImage(),
            icon: Assets.iconmonstrRefreshLined.svg(
              width: 24,
              height: 24,
            ),
          ),
          IconButton(
            onPressed: () => _flipImage(),
            icon: Assets.iconmonstrLayoutVerticalLined.svg(
              width: 24,
              height: 24,
            ),
          ),
        ],
      )),
    );
  }
}
