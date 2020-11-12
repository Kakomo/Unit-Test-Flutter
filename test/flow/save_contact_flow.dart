
import 'package:bytebank/main.dart';
import 'package:bytebank/model/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/MockContactDao.dart';
import '../widget/dashboard_widget_test.dart';
import '../matchers/matchers.dart';

void main(){
  testWidgets('Save_Contact_Test', (tester) async{
   final mockContactDao = MockContactDao();
   await tester.pumpWidget(ByteBank(contactDao: mockContactDao,));
   final dashboard = find.byType(Dashboard);
   expect(dashboard, findsOneWidget);

   final transferFeatureItem = find.byWidgetPredicate((widget) => featureItemMatcher(
       widget, 'Transfer', Icons.monetization_on));
   expect(transferFeatureItem, findsOneWidget);
   await tester.tap(transferFeatureItem);
   await tester.pumpAndSettle();

   verify(mockContactDao.findAll()).called(1);

   final contactList = find.byType(ContactsList);
   expect(contactList, findsOneWidget);

   final fabNewContact = find.widgetWithIcon(FloatingActionButton, Icons.add);
   expect(fabNewContact, findsOneWidget);
   await  tester.tap(fabNewContact);
   await tester.pumpAndSettle();

   final contactForm = find.byType(ContactsForm);
   expect(contactForm, findsOneWidget);

   final nameTextField = find.byWidgetPredicate((widget) {
    if(widget is TextField){
     return widget.decoration.labelText == 'Full Name';
    }
    return false;
   });
   expect(nameTextField, findsOneWidget);
   await tester.enterText(nameTextField, 'Caio');

   final accountNumberTextField = find.byWidgetPredicate((widget) {
    if(widget is TextField){
     return widget.decoration.labelText == 'Account Number';
    }
    return false;
   });
   expect(accountNumberTextField, findsOneWidget);
   await tester.enterText(accountNumberTextField, '5');

   final createButton = find.widgetWithText(RaisedButton, 'Create');
   expect(createButton, findsOneWidget);
   await tester.tap(createButton);
   await tester.pumpAndSettle();
   verify(mockContactDao.save(Contact(0,'Caio', 5)));

   final contactListBack = find.byType(ContactsList);
   expect(contactListBack,findsOneWidget);

   verify(mockContactDao.findAll());



  });
}








