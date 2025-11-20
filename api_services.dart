import 'dart:convert';
import 'package:f/model/Item.dart';

import 'package:http/http.dart' as http;

class apiservice{

  final String baseUrl = "https://jsonplaceholder.typicode.com/posts";

  Future<List<Item>> fetchItems() async {
    final response = await http.get(Uri.parse('$baseUrl'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Item.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load items');
    }
  }

}