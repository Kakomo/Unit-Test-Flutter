import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/http/webclients/transactions_webclient.dart';
import 'package:bytebank/screens/dashboard.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

void main() {
  runApp(ByteBank(
    contactDao: ContactDao(),
    transactionsWebClient: TransactionsWebClient(),
  ));
}

class ByteBank extends StatelessWidget {
  final ContactDao contactDao;
  final TransactionsWebClient transactionsWebClient;

  ByteBank({
    @required this.contactDao,
    @required this.transactionsWebClient,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AppDependencies(
      transactionsWebClient: transactionsWebClient,
      contactDao: contactDao,
      child: MaterialApp(
          theme: ThemeData(
              primaryColor: Colors.green[900],
              accentColor: Colors.blueAccent[700],
              buttonTheme: ButtonThemeData(
                buttonColor: Colors.blueAccent[700],
                textTheme: ButtonTextTheme.primary,
              )),
          home: Dashboard()),
    );
  }
}
