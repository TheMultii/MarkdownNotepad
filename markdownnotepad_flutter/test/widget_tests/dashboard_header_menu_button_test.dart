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

    testWidgets('should have an underline if it\'s a selected card',
        (tester) async {
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

      final BuildContext context = tester.element(find.byType(MaterialApp));

      expect(
        tester
            .widget<AnimatedContainer>(find.byType(AnimatedContainer))
            .decoration,
        BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1.5,
            ),
          ),
        ),
      );
    });

    testWidgets('should not have an underline if it\'s not a selected card',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DashboardHeaderMenuButton(
            text: 'test',
            tab: DashboardTabs.lastViewed,
            selectedTab: DashboardTabs.addedToFavourites,
            onTap: () {},
          ),
        ),
      );

      expect(
        tester
            .widget<AnimatedContainer>(find.byType(AnimatedContainer))
            .decoration,
        const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.transparent,
              width: 1.5,
            ),
          ),
        ),
      );
    });

    testWidgets('should be clickable', (tester) async {
      int counter = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardHeaderMenuButton(
            text: 'test',
            tab: DashboardTabs.lastViewed,
            selectedTab: DashboardTabs.lastViewed,
            onTap: () {
              counter++;
            },
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));

      expect(counter, 1);
    });
  });
}
