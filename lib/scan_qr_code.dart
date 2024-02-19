import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({super.key});

  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  String qrResult = 'Scanned Data will appear here';
  Future<void> scanQR() async {
    try{
      final qrCode = await FlutterBarcodeScanner.scanBarcode('#ff6666', '취소', true, ScanMode.QR);
      if(!mounted) return;
      setState(() {
        qrResult = qrCode.toString();
      });
      //
    } on PlatformException{
      qrResult = 'QR 읽기 실패!';
      //
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR 스캔하기'),) ,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30,),
            Text(qrResult, style: const TextStyle(color: Colors.black),),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: scanQR, child: const Text('스캔하기')),
            
            //
          ],
        ),
      ),
    );
  }
}
