import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ps_app/main.dart';

void main() {
  testWidgets('Test aplikasi jalan', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NasiPonggolApp());

    // Verify that the home screen title exists
    expect(find.text('Menu Nasi Ponggol'), findsOneWidget);
  });
}
