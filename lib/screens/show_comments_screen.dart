import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialfeedplus_parvathi/components/post_card.dart';
import 'package:socialfeedplus_parvathi/notifier/posts_provider.dart';
import 'package:socialfeedplus_parvathi/screens/create_post_screen.dart';

class ShowCommentsScreen extends ConsumerStatefulWidget {
  final int postId;
  const ShowCommentsScreen({super.key, required this.postId});

  @override
  ConsumerState<ShowCommentsScreen> createState() => _ShowCommentsScreenState();
}

class _ShowCommentsScreenState extends ConsumerState<ShowCommentsScreen> {
  @override
  Widget build(BuildContext context) {
    final allPosts = ref.watch(postProvider);
    final post = allPosts.firstWhere((p) => p.postId == widget.postId);

    final validComments =
        post.comments.where((c) => c.text.trim().isNotEmpty).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
            margin: EdgeInsets.only(left: 14, top: 10, bottom: 13),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
            PostCard(post: post, isClickable: false),

            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: ElevatedButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CreatePostScreen(
                        isComment: true,
                        postId: post.postId,
                      ),
                    ),
                  );
                  // After returning, rebuild screen
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff6F8EFC),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
                child: const Text(
                  "Add Comment",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10,),
              child: const Divider(),
            ),

            Expanded(
              child: validComments.isEmpty
                  ? const Center(
                      child: Text(
                        "No comments yet. Be the first to comment!",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: validComments.length,
                      separatorBuilder: (_, __) => const Divider(
                        indent: 16,
                        endIndent: 16,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        final comment = validComments[index];
                        return Padding(
                          padding: EdgeInsets.only(
                              left: 30, top: index==0?0:18, bottom: 30, right: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                comment.text,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    comment.date,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    comment.time,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
