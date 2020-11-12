
import 'package:bytebank/model/transactions.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  test('Test_Transaction_Value', (){
   final transactiontest = Transaction(null,200,null);
   expect(transactiontest.value, 200);
  });
  test('Show_Error_If_Value_Is_Zero', (){
    expect(() => Transaction(null,0,null), throwsAssertionError);
  });
}