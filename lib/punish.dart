import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';  // Uint8List用
import 'package:flutter/foundation.dart';  // kIsWeb用
import 'package:image_picker/image_picker.dart';
// 2. しばき画面
class ShibakiScreen extends StatefulWidget {
  const ShibakiScreen({super.key});

  @override
  State<ShibakiScreen> createState() => _ShibakiScreenState();
}

class _ShibakiScreenState extends State<ShibakiScreen> {
  bool _isRunning = false;
  int _tapCount = 0;
  int _remainingTime = 10;
  Timer? _timer;
  Uint8List? _imageBytes;  // Web/Mobile共通: bytesで保持
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // 画像ピック（Web/Mobile自動対応）
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,  // ギャラリー優先（カメラも可）
        imageQuality: 80,  // 容量軽減
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _imageBytes = bytes;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('画像選択エラー: $e')),
      );
    }
  }

  void _startShibaki() {
    if (_imageBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('先に写真を選択してください')),
      );
      return;
    }
    setState(() {
      _isRunning = true;
      _tapCount = 0;
      _remainingTime = 10;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _finish();
        }
      });
    });
  }

  void _onTap() {
    if (_isRunning && _remainingTime > 0) {
      setState(() {
        _tapCount++;
      });
    }
  }

  void _finish() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
        context,
        '/result',
        arguments: _tapCount,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 写真エリア
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey),
                ),
                child: _imageBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.memory(
                          _imageBytes!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      )
                    : const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library, size: 64, color: Colors.grey),
                            Text('写真を選択（タップ）', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 32),
            // カウントダウン以下同じ...
            Text(
              '$_remainingTime',
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_isRunning) ...[
              const Text('しばくボタンを連打', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 32),
              GestureDetector(
                onTap: _onTap,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$_tapCount',
                      style: const TextStyle(fontSize: 48, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(_remainingTime > 0 ? 'スタート' : 'フィニッシュ', style: const TextStyle(fontSize: 24)),
            ] else ...[
              ElevatedButton(
                onPressed: _startShibaki,
                style: ElevatedButton.styleFrom(minimumSize: const Size(200, 60)),
                child: const Text('スタート', style: TextStyle(fontSize: 20)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}