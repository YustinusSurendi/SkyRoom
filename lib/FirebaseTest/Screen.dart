import 'package:flutter/material.dart';
import 'analyticHelper.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  MyAnalyticsHelper fbAnalytics = MyAnalyticsHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Working with analytics')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  fbAnalytics.testSetUserId('bintang');
                },
                child: const Text("Send Event"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  fbAnalytics.testSetUserProperty();
                },
                child: const Text("Send Property"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  fbAnalytics.testEventLog("send_error");
                },
                child: const Text("Send Error"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
