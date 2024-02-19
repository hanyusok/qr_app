import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:qr_app/custom_style.dart';
import 'package:qr_flutter/qr_flutter.dart';
// import 'package:qr_app/scan_qr_code.dart';

class GenerateQrCode extends StatefulWidget {
  const GenerateQrCode({super.key});

  @override
  State<GenerateQrCode> createState() => _GenerateQrCodeState();
}

class _GenerateQrCodeState extends State<GenerateQrCode> {
  TextEditingController urlController = TextEditingController(text: '');
  String data = '';
  final GlobalKey _qrKey = GlobalKey();
  bool dirExists = false;
  dynamic externalDir = '/storage/emulated/0/Download/Qr_code';

  /* png이미지 생성 및 저장하기 */
  Future<void> captureAndSavePng() async {
    try {
      RenderRepaintBoundary boundary =
          _qrKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      /* drawing white backgorund because QR code is Black */
      final whitePaint = Paint()..color = Colors.white;
      final recorder = PictureRecorder();
      final Uint8List pngBytes;
      final canvas = Canvas(recorder,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()));
      canvas.drawRect(
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          whitePaint);
      canvas.drawImage(image, Offset.zero, Paint());
      final picture = recorder.endRecording();
      final img = await picture.toImage(image.width, image.height);
      ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
      // if (byteData != null) {
      pngBytes = byteData!.buffer.asUint8List();
      //
      // }
      // Uint8List pngBytes = byteData.buffer.asUint8List();
      /* file 이름 및 폴더 중복 체크*/
      String fileName = 'qr_code';
      int i = 1;
      while (await File('$externalDir/$fileName').exists()) {
        fileName = 'qr_code_$i';
        i++;
      }
      /* dir 중복 확인 */
      dirExists = await File(externalDir).exists();
      /* dir 없으면 new dir 생성 */
      if (!dirExists) {
        await Directory(externalDir).create(recursive: true);
        dirExists = true;
      }

      final file = await File('$externalDir/$fileName.png').create();
      await file.writeAsBytes(pngBytes);
      /* 이미지 생성 snackbar 알림 */
      if (!mounted) return;
      const customSnackBar = SnackBar(content: Text('QR코드가 gallery에 저장되었습니다'));
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar);
    } catch (e) {
      log(e.toString());
      /* 이미지 생성 에러 snackbar 알림 */
      if (!mounted) return;
      const customSnackBar = SnackBar(content: Text('QR코드가 gallery에 저장실패!'));
      ScaffoldMessenger.of(context).showSnackBar(customSnackBar);
    }
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR생성'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* QR 컨텐츠 String */
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: urlController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    hintText: '입력하면 QR코드 생성됩니다.',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15)),
                    labelText: '입력하기',
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),
              /* 생성하기 button */
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    data = urlController.text;
                  });
                },
                style: CustomStyle().myBtnStyle,
                child: const Text('생성'),
              ),
              const SizedBox(
                height: 18,
              ),
              /* QR 생성된 이미지 */
              if (urlController.text.isNotEmpty)
                QrImageView(
                  data: data,
                  size: 200,
                ),
              const SizedBox(
                height: 18,
              ),
              /* 저장하기 button */
              ElevatedButton(
                onPressed: captureAndSavePng,
                style: CustomStyle().myBtnStyle,
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
