// Widget smoke test untuk Plantify.PNP.
//
// Test ini memverifikasi bahwa root widget [PlantifyApp] dapat di-render
// tanpa error. Test detail per-screen akan ditambahkan pada Phase berikutnya.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plantify_pnp/app/app.dart';

void main() {
  testWidgets('PlantifyApp smoke test — app renders without error',
      (WidgetTester tester) async {
    // Build root widget
    await tester.pumpWidget(const PlantifyApp());

    // Verifikasi bahwa widget tree terbentuk (tidak crash)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
