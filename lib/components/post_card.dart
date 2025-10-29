import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialfeedplus_parvathi/models/post.dart';
import 'package:socialfeedplus_parvathi/notifier/posts_provider.dart';
import 'package:socialfeedplus_parvathi/screens/show_comments_screen.dart';


class PostCard extends ConsumerWidget {
  final PostModel post;
  final bool isClickable;

  const PostCard({
    Key? key,
    required this.post,
    this.isClickable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                (post.profileImage == null)
                    ? const Icon(Icons.person, size: 48)
                    : Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade400,
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(post.profileImage!),
                          radius: 24,
                        ),
                      ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(post.username,
                        style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                Text(post.date,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 10),

            // Caption
            Text(post.caption,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),

            const SizedBox(height: 8),

            // Image
            if (post.imagePath != null && post.imagePath!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(post.imagePath!, fit: BoxFit.contain),
              ),

            const SizedBox(height: 8),

            // Footer
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.comment_outlined,
                      size: 22, color: Colors.deepPurple),
                  onPressed: isClickable
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShowCommentsScreen(
                                postId:post.postId,
                              ),
                            ),
                          );
                        }
                      : null, // Disable if used in comments screen
                ),
                Text("${post.commentCount}",
                    style: const TextStyle(color: Colors.deepPurple)),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                    color: post.isLiked ? Colors.red : Colors.grey,
                    size: 22,
                  ),
                  onPressed: () {
                    ref.read(postProvider.notifier).toggleLike(post.postId);
                  },
                ),
                Text("${post.likes.toInt()}",
                    style: TextStyle(
                        color: post.isLiked ? Colors.red : Colors.grey)),
                const Spacer(),
                Text(post.time,
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
