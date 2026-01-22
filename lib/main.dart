import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NativeCameraScreen(),
    );
  }
}

class NativeCameraScreen extends StatefulWidget {
  @override
  _NativeCameraScreenState createState() => _NativeCameraScreenState();
}

class _NativeCameraScreenState extends State<NativeCameraScreen> {
  static const platform = MethodChannel('com.example.app14/native');

  String _nativeMessage = "Повідомлення ще не отримано";
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _getNativeString() async {
    try {
      final String result = await platform.invokeMethod('getNativeString');
      setState(() {
        _nativeMessage = result;
      });
    } on PlatformException catch (e) {
      setState(() {
        _nativeMessage = "Помилка: ${e.message}";
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab14')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_nativeMessage, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: _getNativeString,
                child: const Text('Отримати нативний рядок'),
              ),

              const Divider(height: 50),

              _image == null
                  ? const Text('Фото ще не зроблено')
                  : Image.file(_image!, height: 300),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _takePhoto,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Зробити фото'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}