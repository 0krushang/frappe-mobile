import 'dart:convert';

import 'package:dio/dio.dart';
import '../../../frappe_mobile.dart';
import '../../models/bar_item.dart';

class BottomBarApiService {
  static final BottomBarApiService _instance = BottomBarApiService._internal();
  factory BottomBarApiService() => _instance;
  BottomBarApiService._internal();

  final ApiClient _client = ApiClient();


   Future<List<BottomBarItem>> fetchBottomBarConfig(String role) async {
    try {
      final response = await _client.get('/api/resource/BottomBarConfig/$role',
      includeAuth: true,);
      final data = response.data;
      if (data['data'] == null || data['data'].isEmpty) return [];
      final itemsTable = data['data']['items'] as List;
      return itemsTable.map((item) => BottomBarItem.fromJson(item)).toList();
    } on DioException catch (e) {
      // Customize error handling/logging as needed
      print('Dio error: ${e.response?.data ?? e.message}');
      return [];
    }
  }
}