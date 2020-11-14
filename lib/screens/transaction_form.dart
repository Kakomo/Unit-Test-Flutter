import 'dart:async';

import 'package:bytebank/components/progress.dart';
import 'package:bytebank/components/response_dialog.dart';
import 'package:bytebank/components/transaction_auth_dialog.dart';
import 'package:bytebank/http/webclient.dart';
import 'package:bytebank/http/webclients/transactions_webclient.dart';
import 'package:bytebank/model/contact.dart';
import 'package:bytebank/model/transactions.dart';
import 'package:bytebank/widgets/app_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TransactionForm extends StatefulWidget {
  final Contact contact;

  TransactionForm(this.contact);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final TextEditingController _valueController = TextEditingController();
  final String transactionId = Uuid().v4();

  bool _sending = false;

  @override
  Widget build(BuildContext context) {
    final dependencies = AppDependencies.of(context);
    print('The Transacton UUID is: $transactionId');
    return Scaffold(
      appBar: AppBar(
        title: Text('New transaction'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Visibility(
                visible: _sending,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Progress(message: 'Sending...',),
                ),
              ),
              Text(
                widget.contact.name,
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  widget.contact.accountNumber.toString(),
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  controller: _valueController,
                  style: TextStyle(fontSize: 24.0),
                  decoration: InputDecoration(labelText: 'Value'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: SizedBox(
                  width: double.maxFinite,
                  child: RaisedButton(
                    child: Text('Transfer'),
                    onPressed: () {
                      final double value =
                          double.tryParse(_valueController.text);
                      final transactionCreated =
                          Transaction(transactionId,value, widget.contact);
                      showDialog(
                          context: context,
                          builder: (contextDialog) {
                            return TransactionsAuthDialog(
                              onConfirm: (String password) {
                                _save(dependencies.transactionsWebClient,transactionCreated, password, context);
                              },
                            );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _save(TransactionsWebClient webClient, Transaction transactionCreated, String password,
      BuildContext context) async {
    Transaction transaction = await _send(webClient,transactionCreated, password, context);
    if (transaction != null) {
      await _showSuccessfulMessage(context);
      Navigator.pop(context);
    }
  }

  Future _showSuccessfulMessage(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (contextDialog) {
          return SuccessDialog('Successful Transaction');
        });
  }

  Future<Transaction> _send(TransactionsWebClient webClient, Transaction transactionCreated, String password, BuildContext context) async {
    setState(() {
      _sending =true;
    });
    final Transaction transaction =
        await webClient.save(transactionCreated, password).catchError((error) {
          _showFailureMessage(context,message: error.message);
        }, test: (error) => error is HttpException).catchError((error){
          _showFailureMessage(context,message: 'I could not talk to the server');
        },test: (error) => error is TimeoutException).catchError((error){
          _showFailureMessage(context);
        },test: (error) => error is Exception);
    setState(() {
      _sending = false;
    });
    return transaction;
  }

  void _showFailureMessage(BuildContext context,{String message = 'Unknown Error'}) {
    showDialog(
        context: context,
        builder: (contextDialog) {
          return FailureDialog(message);
        });
  }
}
