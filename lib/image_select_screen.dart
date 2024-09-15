import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_handson_edit_image/edit_snap_screen.dart';
import 'package:image/image.dart' as image_lib;
import 'package:image_picker/image_picker.dart';


class ImageSelectScreen extends StatefulWidget {
  const ImageSelectScreen({super.key});

  @override
  State<ImageSelectScreen> createState() => _ImageSelectScreenState();
}

class _ImageSelectScreenState extends State<ImageSelectScreen> {
  // Image Picker : 画像ライブラリ、カメラアクセスの機能
  final ImagePicker _picker = ImagePicker();

  // 8bit　符号なし整数のリスト（状態変数）
  Uint8List? _imageBitmap;

  Future<void> _selectImage() async {
    // 画像選択（ファイルで返却）
    final XFile? imageFile =
        await _picker.pickImage(source: ImageSource.gallery);

    // ファイルオブジェクトから画像データを取り出す
    final imageBitmap = await imageFile?.readAsBytes();
    // null チェック
    assert(imageBitmap != null);
    if (imageBitmap == null) return;

    // 画像データをデコード
    final image = image_lib.decodeImage(imageBitmap);
    assert(image != null);
    if (image == null) return;

    // 画像データ＋メタデータのクラス
    final image_lib.Image resizedImage;
    if (image.width > image.height) {
      // 横長の画像の場合は縦幅を500pxにリサイズ
      resizedImage = image_lib.copyResize(image, width: 500);
    } else {
      // 縦長の画像の場合は横幅を500pxにリサイズ
      resizedImage = image_lib.copyResize(image, height: 500);
    }

    // 画像をエンコードして状態を更新する
    setState(() {
      _imageBitmap = image_lib.encodeBmp(resizedImage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final imageBitmap = _imageBitmap; // 画像
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(l10n.imageSelectScreenTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageBitmap != null) Image.memory(imageBitmap),
            ElevatedButton(
              onPressed: () => _selectImage(),
              child: Text(l10n.imageSelect),
            ),
            if (imageBitmap != null)
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ImageEditScreen(imageBitmap: imageBitmap),
                  ),
                ),
                child: Text(l10n.imageEdit),
              ),
          ],
        ),
      ),
    );
  }
}
