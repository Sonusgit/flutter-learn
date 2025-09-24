import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../models/topic_model.dart';

class ApiService extends GetxService {
  late Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio();
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(seconds: 3);
  }

  Future<List<TopicModel>> loadTopicsFromAssets() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/topics.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => TopicModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load topics from assets: $e');
    }
  }

  // Future method for API calls (if needed)
  Future<List<TopicModel>> fetchTopicsFromAPI() async {
    try {
      final response = await _dio.get('your-api-endpoint');
      final List<dynamic> jsonData = response.data;
      return jsonData.map((json) => TopicModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('API Error: ${e.message}');
    }
  }
}
