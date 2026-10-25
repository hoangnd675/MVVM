import 'package:flutter/foundation.dart';

import '../models/post.dart';
import '../services/api_exception.dart';
import '../services/post_service.dart';

enum PostStatus { loading, success, error }

class PostViewModel extends ChangeNotifier {
  final PostService _service;
  PostStatus _status = PostStatus.loading;
  List<Post> _posts = [];
  String _errorMessage = '';
  bool _isFetching = false;
  bool _isDisposed = false;

  PostViewModel(this._service);

  PostStatus get status => _status;
  List<Post> get posts => List.unmodifiable(_posts);
  String get errorMessage => _errorMessage;

  Future<void> loadPosts() async {
    if (_isFetching || _isDisposed) return;

    _isFetching = true;
    _status = PostStatus.loading;
    _errorMessage = '';
    notifyListeners();

    try {
      final posts = await _service.fetchPosts();
      if (_isDisposed) return;

      _posts = posts;
      _status = PostStatus.success;
    } on ApiException catch (error) {
      if (_isDisposed) return;

      _errorMessage = error.message;
      _status = PostStatus.error;
    } catch (_) {
      if (_isDisposed) return;

      _errorMessage = 'Không thể tải dữ liệu. Vui lòng thử lại.';
      _status = PostStatus.error;
    } finally {
      _isFetching = false;
      if (!_isDisposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
