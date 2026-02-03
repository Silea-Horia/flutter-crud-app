import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/model.dart';

class ApiService {
  final int port = 2627;
  late final String baseUrl = 'http://10.0.2.2:$port';
  final String endpoint = 'payment';
  final String pluralEndpoint = 'payments';
  late final String allEndpoint = 'allPayments';

  Future<List<Payment>> getAll() async {
    log('Fetching data from server');
    try {
      final response = await http.get(Uri.parse('$baseUrl/$pluralEndpoint'));
      final List<dynamic> responseJson = json.decode(response.body);
      return responseJson.map((json) => Payment.fromJson(json)).toList();
    } on Exception {
      log('Failed to fetch data from server.');
      throw Exception('Server offline');
    }
  }

  Future<Payment> post(Payment ticket) async {
    log('Posting data to server');
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(ticket.toJson()),
    );
    return Payment.fromJson(json.decode(response.body));
  }

  Future<Payment> getById(int id) async {
    log('Fetching data by id from server');
    final response = await http.get(Uri.parse('$baseUrl/$endpoint/$id'));

    return Payment.fromJson(json.decode(response.body));
  }

  Future<void> delete(int id) async {
    log('Deleting data from server');
    await http.delete(Uri.parse('$baseUrl/$endpoint/$id'));
  }

  Future<List<Payment>> getAllPayments() async {
    log('Accessing the $allEndpoint endpoint');
    try {
      final response = await http.get(Uri.parse('$baseUrl/$allEndpoint'));
      final List<dynamic> responseJson = json.decode(response.body);
      return responseJson.map((json) => Payment.fromJson(json)).toList();
    } on Exception {
      log('Error accessing the $allEndpoint endpoint');
      throw Exception('Server offline');
    }
  }

  Stream get ticketStream {
    final channel = WebSocketChannel.connect(Uri.parse('ws://10.0.2.2:$port'));
    log('Listening to the socket channel.');
    return channel.stream;
  }
}
