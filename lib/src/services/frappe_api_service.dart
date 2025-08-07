import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/bar_item.dart';

class FrappeApiService {
  final String frappeBaseUrl;
  final String apiKey;
  final String apiSecret;
  final Dio dio;

  FrappeApiService(this.frappeBaseUrl, this.apiKey, this.apiSecret)
      : dio = Dio(BaseOptions(
    baseUrl: frappeBaseUrl,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'token $apiKey:$apiSecret',
    },
  ));

  Future<List<BottomBarItem>> fetchBottomBarConfig(String role) async {
    try {
      final response = await dio.get('/api/resource/BottomBarConfig/$role',);
      final data = response.data;
      print("data$data");
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