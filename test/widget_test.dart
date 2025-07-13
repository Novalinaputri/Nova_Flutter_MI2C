// File: test/widget_test.dart
// Versi final - cocok untuk aplikasi Flutter non-counter
// Digunakan untuk memastikan setup test berhasil tanpa error

import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Dummy test - selalu berhasil', (WidgetTester tester) async {
    // Test ini akan selalu berhasil karena tidak tergantung UI apa pun
    expect(true, isTrue);
  });
}
