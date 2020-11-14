import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/http/webclients/transactions_webclient.dart';
import 'package:flutter/cupertino.dart';

class AppDependencies extends InheritedWidget {
  final ContactDao contactDao;
  final TransactionsWebClient transactionsWebClient;
  final Widget child;

  AppDependencies({
    @required this.contactDao,
    @required this.transactionsWebClient,
    @required this.child,
  }) : super(child: child);

  static AppDependencies of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppDependencies>();
  }

  @override
  bool updateShouldNotify(AppDependencies oldWidget) {
    return contactDao != oldWidget.contactDao ||
        transactionsWebClient != oldWidget.transactionsWebClient;
  }
}
