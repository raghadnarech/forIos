import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class QRImage extends StatefulWidget {
  QRImage(this.controller, {super.key});
  final String controller;

  @override
  State<QRImage> createState() => _QRImageState();
}

class _QRImageState extends State<QRImage> {
  final screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qr'),
        centerTitle: true,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Screenshot(
              controller: screenshotController,
              child: Center(
                child: QrforImage(),
              ),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      final imageFile = await screenshotController
                          .captureFromWidget(QrforImage());
                      if (imageFile == null) return;
                      saveAndShare(imageFile);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("مشاركة"), Icon(Icons.share)],
                    )),
                ElevatedButton(
                    onPressed: () async {
                      final imageFile = await screenshotController
                          .captureFromWidget(QrforImage());
                      if (imageFile == null) return;
                      var data = await saveImage(imageFile);
                      if (data['isSuccess'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green,
                          content: Text("تم حفظ الصورة في المعرض"),
                          elevation: 5,
                          duration: Duration(seconds: 7),
                        ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          content: Text("حدث خطأ, الرجاء إعادة المحاولة"),
                          duration: Duration(seconds: 7),
                        ));
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("تحميل"), Icon(Icons.download)],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future saveAndShare(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = 'ََQR_Code_$time';
    final directory = await getApplicationDocumentsDirectory();
    final image = File('${directory.path}/$name.png');
    image.writeAsBytesSync(bytes);
    await Share.shareFiles([image.path]);
  }

  Future<Map> saveImage(Uint8List bytes) async {
    await [Permission.storage].request();
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll('.', '_')
        .replaceAll(':', '_');
    final name = 'QrCode_$time';

    final result =
        await ImageGallerySaver.saveImage(bytes, name: name, quality: 100);
    return result;
  }

  Widget QrforImage() {
    return Center(
      child: QrImage(
        backgroundColor: Colors.white,
        data: widget.controller,
        size: 280,
        // You can include embeddedImageStyle Property if you
        //wanna embed an image from your Asset folder
        embeddedImageStyle: QrEmbeddedImageStyle(
          size: const Size(
            100,
            100,
          ),
        ),
      ),
    );
  }
}
