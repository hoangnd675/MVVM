import 'package:flutter/material.dart';

import '../viewmodels/post_view_model.dart';
import 'post_card.dart';

class PostListView extends StatelessWidget {
  final PostViewModel viewModel;

  const PostListView({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Danh sách bài viết'),
            actions: [
              IconButton(
                tooltip: 'Tải lại',
                onPressed: viewModel.status == PostStatus.loading
                    ? null
                    : viewModel.loadPosts,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: _buildBody(),
        );
      },
    );
  }

  Widget _buildBody() {
    switch (viewModel.status) {
      case PostStatus.loading:
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Đang tải bài viết...'),
            ],
          ),
        );
      case PostStatus.error:
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(viewModel.errorMessage, textAlign: TextAlign.center),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: viewModel.loadPosts,
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          ),
        );
      case PostStatus.success:
        final posts = viewModel.posts;
        if (posts.isEmpty) {
          return const Center(child: Text('Chưa có bài viết.'));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: posts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemBuilder: (context, index) => PostCard(post: posts[index]),
        );
    }
  }
}
