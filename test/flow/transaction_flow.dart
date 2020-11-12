import 'package:bytebank/main.dart';
import 'package:bytebank/model/contact.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../matchers/matchers.dart';
import '../mocks/MockContactDao.dart';

void main() {
  testWidgets('Create_New_Transaction_Test', (tester) async {
    final mockContactDao = MockContactDao();
    await tester.pumpWidget(ByteBank(
      contactDao: mockContactDao,
    ));
    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final transferFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
    expect(transferFeatureItem, findsOneWidget);

    when(mockContactDao.findAll()).thenAnswer((realInvocation) async{
      debugPrint('Name Invocation: ${realInvocation}');
      return [Contact(0,'Myself', 1)];
    });

    await tester.tap(transferFeatureItem);
    await tester.pumpAndSettle();

    verify(mockContactDao.findAll()).called(1);

    final contactList = find.byType(ContactsList);
    expect(contactList, findsOneWidget);

    final contactItem = find.byWidgetPredicate((widget) {
      if (widget is ContactItem) {
        return widget.contact.name == 'Myself' &&
            widget.contact.accountNumber == 1;
      }
      return false;
    });
    expect(contactItem, findsOneWidget);
    await tester.tap(contactItem);
    await tester.pumpAndSettle();

    final transactionForm = find.byType(TransactionForm);
    expect(transactionForm, findsOneWidget);

  });
}
