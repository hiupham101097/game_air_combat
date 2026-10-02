import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini__game2/view/main/inventory_screen.dart';

void main() {
  testWidgets('equipment upgrade costs wrap within narrow cards',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 72,
            child: UpgradeResourceCosts(
              stoneCost: 12345,
              coreCost: 54321,
              stonesAffordable: true,
              coresAffordable: false,
            ),
          ),
        ),
      ),
    );

    expect(find.text('12345'), findsOneWidget);
    expect(find.text('54321'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
