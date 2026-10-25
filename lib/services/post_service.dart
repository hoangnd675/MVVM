import 'dart:async';

import 'package:http/http.dart' as http;

import '../models/post.dart';
import 'api_exception.dart';

class PostService {
  final http.Client _client;
  final Uri _endpoint;
  final Duration _timeout;

  PostService({
    required http.Client client,
    required Uri endpoint,
    Duration timeout = const Duration(seconds: 15),
  })  : _client = client,
        _endpoint = endpoint,
        _timeout = timeout;

  Future<List<Post>> fetchPosts() async {
    try {
      final response = await _client.get(_endpoint).timeout(_timeout);

      if (response.statusCode != 200) {
        throw ApiException(
          'Không tải được bài viết (HTTP ${response.statusCode}).',
        );
      }

      return Post.parseList(response.body);
    } on TimeoutException {
      throw const ApiException('Kết nối quá thời gian chờ. Vui lòng thử lại.');
    } on http.ClientException {
      throw const ApiException('Không thể kết nối. Hãy kiểm tra mạng.');
    } on FormatException {
      throw const ApiException('Dữ liệu trả về không đúng định dạng.');
    }
  }
}
