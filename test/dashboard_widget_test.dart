import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  testWidgets('Show_One_Image_On_Dashboard', (WidgetTester tester) async{
   await tester.pumpWidget(MaterialApp(home: Dashboard()));
    final mainImage = find.byType(Image);
    expect(mainImage, findsOneWidget);
  });
  testWidgets('Show_FeatureItems_On_Dashboard', (tester) async{
    await tester.pumpWidget(MaterialApp(home: Dashboard()));
    final featureItemWidget = find.byType(FeatureItem);
    expect(featureItemWidget, findsWidgets);
  });

}







