import 'package:flutter/material.dart';
import 'dart:async';
// pubspec.yaml追加後
// ShibakiScreenでボタン追加し、getImage(ImgSource.Both)で画像取得後Image.file表示。[]

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'しばきアプリ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/shibaki': (context) => const ShibakiScreen(),
        '/result': (context) => const ResultScreen(),
        '/info': (context) => const InfoScreen(),
        '/thanks': (context) => const ThanksScreen(),
      },
    );
  }
}

// 1. ホーム画面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 上半分: サービスロゴ
          const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.flash_on, size: 100, color: Colors.deepPurple),
                  Text(
                    'しばきアプリ',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Text('街のモヤモヤをスカッと！', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ),
          // 下半分: ボタン二つ
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/shibaki'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  child: const Text('しばき始める', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/info'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 60),
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('情報提供をする', style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startShibaki() {
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
    if (_isRunning) {
      setState(() {
        _tapCount++;
      });
    }
  }

  void _finish() {
    _timer?.cancel();
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
            // 写真エリア (仮: プレースホルダー、後でimage_picker使用)
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera, size: 64, color: Colors.grey),
                    Text('写真を選択/撮影してください', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // カウントダウン
            Text(
              '$_remainingTime',
              style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // テキストとボタン
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

// 3. 結果画面
class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final int tapCount = ModalRoute.of(context)?.settings.arguments as int? ?? 0;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'しばいた回数: $tapCount回',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/shibaki'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('もう一度'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/info'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('情報提供'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: Colors.grey,
              ),
              child: const Text('ホームに戻る'),
            ),
          ],
        ),
      ),
    );
  }
}

// 4. 情報提供画面
class InfoScreen extends StatefulWidget {
  const InfoScreen({super.key});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('情報提供')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(//const消去
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '写真に対するコメント',
                hintText: '危険行為の詳細を入力してください',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/thanks'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('提供'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 56),
                backgroundColor: Colors.grey,
              ),
              child: const Text('ホームへ'),
            ),
          ],
        ),
      ),
    );
  }
}

// 5. 感謝画面
class ThanksScreen extends StatelessWidget {
  const ThanksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.thumb_up, size: 100, color: Colors.green),
            const SizedBox(height: 32),
            const Text(
              '情報提供ありがとうございます！\nみんなの安全に貢献しました。',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
              child: const Text('ホームへ'),
            ),
          ],
        ),
      ),
    );
  }
}
