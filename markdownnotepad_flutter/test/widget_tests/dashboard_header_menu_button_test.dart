import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:markdownnotepad/components/dashboard/dashboard_header_menu_button.dart';
import 'package:markdownnotepad/enums/dashboard_tabs.dart';

void main() {
  group('DashboardHeaderMenuButton tests', () {
    testWidgets('should have display a provided text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DashboardHeaderMenuButton(
            text: 'test',
            tab: DashboardTabs.lastViewed,
            selectedTab: DashboardTabs.lastViewed,
            onTap: () {},
          ),
        ),
      );

      expect(find.text('test'), findsOneWidget);
    });
  });
}
