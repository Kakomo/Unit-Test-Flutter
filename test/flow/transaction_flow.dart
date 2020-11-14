import 'dart:math';

import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclients/transactions_webclient.dart';
import 'package:bytebank/main.dart';
import 'package:bytebank/model/contact.dart';
import 'package:bytebank/model/transactions.dart';
import 'package:bytebank/screens/contacts_list.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../matchers/matchers.dart';
import '../mocks/MockContactDao.dart';
import '../mocks/MockTransactionsWebClient.dart';

void main() {
  testWidgets('Create_New_Transaction_Test', (tester) async {
    final mockContactDao = MockContactDao();
    final mockTransactionsWebClient = MockTransactionsWebClient();
    await tester.pumpWidget(ByteBank(
      transactionsWebClient: mockTransactionsWebClient,
      contactDao: mockContactDao,
    ));
    final dashboard = find.byType(Dashboard);
    expect(dashboard, findsOneWidget);

    final transferFeatureItem = find.byWidgetPredicate((widget) =>
        featureItemMatcher(widget, 'Transfer', Icons.monetization_on));
    expect(transferFeatureItem, findsOneWidget);

    when(mockContactDao.findAll()).thenAnswer((realInvocation) async {
      return [Contact(0, 'Myself', 1)];
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

    final contactName = find.text('Myself');
    expect(contactName, findsOneWidget);
    final contactAccountNumber = find.text('Myself');
    expect(contactAccountNumber, findsOneWidget);

    final textFieldValue = find.byWidgetPredicate((widget) {
      return textFieldByLabelText(widget, 'Value');
    });
    expect(textFieldValue, findsOneWidget);
    await tester.enterText(textFieldValue, '200');

    final transferButton = find.widgetWithText(RaisedButton, 'Transfer');
    expect(transferButton, findsOneWidget);
    await tester.tap(transferButton);
    await tester.pumpAndSettle();

    final transactionAuthDialog = find.byType(TransactionsAuthDialog);
    expect(transactionAuthDialog, findsOneWidget);

    final textFieldAuth = find.byKey(transactionAuthDialogTextFieldPasswordKey);
    expect(textFieldAuth, findsOneWidget);
    await tester.enterText(textFieldAuth, '1000');

    final cancelButton = find.widgetWithText(FlatButton, 'Cancel');
    expect(cancelButton, findsOneWidget);
    final confirmButton = find.widgetWithText(FlatButton, 'Confirm');
    expect(confirmButton, findsOneWidget);

    when(mockTransactionsWebClient.save(
            Transaction(null, 200, Contact(0, 'Myself', 1)), '1000'))
        .thenAnswer((_) async {
     return Transaction(null, 200, Contact(0, 'Myself', 1));
    });

    await tester.tap(confirmButton);
    await tester.pumpAndSettle();

    final sucessDialog = find.byType(SuccessDialog);
    expect(sucessDialog,findsOneWidget);

    final okButton = find.widgetWithText(FlatButton, 'Ok');
    expect(okButton,findsOneWidget);

    await tester.tap(okButton);
    await tester.pumpAndSettle();

    final contactsListBack = find.byType(ContactsList);
    expect(contactsListBack,findsOneWidget);
  });
}
