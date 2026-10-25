import 'dart:convert';

class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    if (json['id'] is! int ||
        json['userId'] is! int ||
        json['title'] is! String ||
        json['body'] is! String) {
      throw const FormatException('Bài viết không đúng cấu trúc.');
    }

    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  static List<Post> parseList(String responseBody) {
    final dynamic data = jsonDecode(responseBody);
    if (data is! List) {
      throw const FormatException('Dữ liệu phải là danh sách.');
    }

    final posts = <Post>[];
    for (final dynamic item in data) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Bài viết không hợp lệ.');
      }
      posts.add(Post.fromJson(item));
    }
    return posts;
  }
}
