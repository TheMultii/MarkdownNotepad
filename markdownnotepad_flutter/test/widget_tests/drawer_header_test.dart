import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdownnotepad/components/drawer/drawer_header.dart';

void main() {
  group('DrawerHeader tests', () {
    testWidgets('should have a image logo', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MDNDrawerHeader(),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should have a "MDN Notepad" Text widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: MDNDrawerHeader(),
        ),
      );

      expect(find.text('MDN Notepad'), findsOneWidget);
    });
  });
}
