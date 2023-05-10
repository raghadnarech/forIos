import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_app/Views/Admin/qr_image.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class GenerateQRCode extends StatefulWidget {
  const GenerateQRCode({super.key});

  @override
  GenerateQRCodeState createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  TextEditingController controller = TextEditingController();
  var dateformat = DateFormat('yyyy-MM-dd').format(DateTime.now());
  void _showdatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2024),
    ).then((value) {
      setState(() {
        dateformat = "${DateFormat('yyyy-MM-dd').format(value!)}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenshotController = ScreenshotController();
    var dateformat = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return Scaffold(
      body:
// Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                   margin: const EdgeInsets.all(20),
//                   child: ElevatedButton(
//                       onPressed: () {
//                         _showdatePicker();
//                       },
//                       child: Text("اختر التاريخ"))),
//               Text(dateformat.toString()),
//               ElevatedButton(
//                   onPressed: () async {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: ((context) {
//                           return QRImage(dateformat.toString());
//                         }),
//                       ),
//                     );
//                   },
//                   child: const Text('إنشاء QR')),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
          Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Screenshot(
              controller: screenshotController,
              child: Center(
                child: QrforImage(dateformat),
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
                          .captureFromWidget(QrforImage(dateformat));
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
                          .captureFromWidget(QrforImage(dateformat));
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

  Widget QrforImage(String? data) {
    return Center(
      child: QrImage(
        backgroundColor: Colors.white,
        data: data!,
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
