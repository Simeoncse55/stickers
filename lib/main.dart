import 'package:flutter/material.dart';
import 'package:whatsapp_stickers_exporter/whatsapp_stickers_exporter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Stickers',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final WhatsappStickersExporter _whatsAppStickersExporter =
  WhatsappStickersExporter();

  static const stickerAssets = [
    'assets/sticker1.webp',
    'assets/sticker2.webp',
    'assets/sticker3.webp',
  ];

  List<List<String>> stickerSet = [];

  @override
  void initState() {
    super.initState();
    _loadStickerImages();
  }

  Future<void> _loadStickerImages() async {
    // Load sticker images asynchronously
    for (var s in stickerAssets) {
      final stickerPath = await WhatsappStickerImage.fromAsset(s).path;
      stickerSet.add([stickerPath, '']); // Add sticker path and placeholder emoji
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WhatsApp Stickers'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/sticker.png', width: 100, height: 100),
            SizedBox(height: 20),
            ElevatedButton(
              // onPressed: stickerSet.isNotEmpty ? _addStickerToWhatsApp : null,
              onPressed:_addStickerToWhatsApp ,
              child: Text('Add to WhatsApp'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addStickerToWhatsApp() async {
    try {
      if (stickerSet.isEmpty) {
        throw Exception('Sticker list is empty');
      }

      // Sticker Pack Information
      const trayImagePath = 'assets/tray_image.png';
      String identifier = 'sticker_pack_1';
      String name = 'My Sticker Pack';
      String publisher = 'Publisher';

      // Load tray icon image
      final trayImage = await WhatsappStickerImage.fromAsset(trayImagePath).path;

      // Add sticker pack to WhatsApp
      await _whatsAppStickersExporter.addStickerPack(
        identifier,
        name,
        publisher,
        trayImage,
        null,
        null,
        null,
        false,
        stickerSet,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Sticker Pack Added to WhatsApp'),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: $e'),
      ));
      print('Error: $e');
    }
  }
}
