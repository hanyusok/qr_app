import 'package:flutter/material.dart';
import 'package:qr_app/generate_qr_code.dart';
import 'package:qr_app/scan_qr_code.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Code Scanner and Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR 만들기 and 스캔'), centerTitle: true,
      backgroundColor: Colors.blue,),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: (){
            setState(() {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScanQrCode()));
            });
          }, child: const Text('QR 스캔')),
          const SizedBox(height: 40,),
          ElevatedButton(onPressed: (){
            setState(() {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const GenerateQrCode()));
            });
          }, child: const Text('QR 생성')),
        ],
      ),
    );
  }
}
