import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:resume_iq/main.dart';

void main() {
  testWidgets('ResumeIQApp builds without error', (WidgetTester tester) async {
    await tester.pumpWidget(const ResumeIQApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
