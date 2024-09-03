import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ackaf/src/data/globals.dart';
import 'package:ackaf/src/data/models/events_model.dart';
import 'package:ackaf/src/data/models/transaction_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'transactions_api.g.dart';

const String baseUrl = 'http://43.205.89.79/api/v1';

@riverpod
Future<List<Transaction>> fetchTransactions(
    FetchTransactionsRef ref, String token) async {
  final url = Uri.parse('$baseUrl/payments/user/$id');
  print('Requesting URL: $url');
  final response = await http.get(
    url,
    headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token"
    },
  );
  print('hello');
  print(json.decode(response.body)['status']);
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    print(response.body);
    List<Transaction> transactions = [];

    for (var item in data) {
      transactions.add(Transaction.fromJson(item));
    }
    print(transactions);
    return transactions;
  } else {
    print(json.decode(response.body)['message']);

    throw Exception(json.decode(response.body)['message']);
  }
}
