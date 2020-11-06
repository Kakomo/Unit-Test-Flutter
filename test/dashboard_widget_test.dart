import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Show_One_Image_On_Dashboard', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    final mainImage = find.byType(Image);
    expect(mainImage, findsOneWidget);
  });
  testWidgets('Show_Transfer_FeatureItem_On_Dashboard', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    final transferFeatureItem = find.byWidgetPredicate((widget) {
      return featureItemMatcher(widget, 'Transfer', Icons.monetization_on);
    });
    expect(transferFeatureItem, findsOneWidget);
  });
  testWidgets('Show_TransactionFeed_FeatureItem_On_Dashboard', (tester) async {
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    final transactionFeedFeatureItem = find.byWidgetPredicate((widget) {
   return featureItemMatcher(widget, 'Transaction Feed', Icons.description);
    });
    expect(transactionFeedFeatureItem, findsOneWidget);
        });
}

bool featureItemMatcher(Widget widget, String name, IconData icon) {
  if (widget is FeatureItem) {
    return widget.name == name &&
        widget.icon == icon;
  }
  return false;
}
