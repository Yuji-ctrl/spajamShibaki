import 'package:flutter/material.dart';
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