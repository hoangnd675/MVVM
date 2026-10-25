import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'services/post_service.dart';
import 'viewmodels/post_view_model.dart';
import 'views/post_list_view.dart';

void main() {
  runApp(const PostApp());
}

class PostApp extends StatefulWidget {
  const PostApp({super.key});

  @override
  State<PostApp> createState() => _PostAppState();
}

class _PostAppState extends State<PostApp> {
  late final http.Client _client;
  late final PostViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _client = http.Client();
    final service = PostService(
      client: _client,
      endpoint: Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    );
    _viewModel = PostViewModel(service);
    _viewModel.loadPosts();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chủ đề 4 - MVVM',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: PostListView(viewModel: _viewModel),
    );
  }
}
