import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialfeedplus_parvathi/data/dummy_posts.dart';
import 'package:socialfeedplus_parvathi/models/comments.dart';
import 'package:socialfeedplus_parvathi/models/post.dart';

class PostNotifier extends StateNotifier<List<PostModel>> {
  PostNotifier() : super([]) {
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final storedData = prefs.getStringList('posts');

    if (storedData != null && storedData.isNotEmpty) {
      // decode each post from stored JSON string
      state = storedData.map((jsonStr) => PostModel.fromJson(jsonStr)).toList();
    } else {
      // fallback to dummy posts on first launch
      state = dummyPosts;
    }
  }

  Future<void> _savePosts() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.map((post) => post.toJson()).toList();
    await prefs.setStringList('posts', jsonList);
  }

  void addPost(PostModel newPost) {
    state = [newPost, ...state];
    _savePosts();
  }

  void removePost(int postId) {
    state = state.where((p) => p.postId != postId).toList();
    _savePosts();
  }

  void toggleLike(int postId) {
    state = state.map((p) {
      if (p.postId == postId) {
        final newLikes = p.isLiked ? (p.likes - 1) : (p.likes + 1);
        return p.copyWith(likes: newLikes, isLiked: !p.isLiked);
      }
      return p;
    }).toList();

    _savePosts();
  }

  Future<void> clearPosts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('posts');
    state = dummyPosts;
  }

void addComment(int postId, CommentModel newComment) {
  state = state.map((post) {
    if (post.postId == postId) {
      // Merge new comment with existing ones
      final updatedComments = [...post.comments, newComment];

      // If dummy post had old commentCount but empty comments list, preserve it
      final updatedCount = post.commentCount + 1;

      return post.copyWith(
        comments: updatedComments,
        commentCount: updatedCount,
      );
    }
    return post;
  }).toList();

  _savePosts();
}

}

final postProvider = StateNotifierProvider<PostNotifier, List<PostModel>>(
  (ref) => PostNotifier(),
);
