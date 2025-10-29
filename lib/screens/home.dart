import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socialfeedplus_parvathi/components/post_card.dart';
import 'package:socialfeedplus_parvathi/models/post.dart';
import 'package:socialfeedplus_parvathi/notifier/posts_provider.dart';
import 'package:socialfeedplus_parvathi/screens/create_post_screen.dart';


class Home extends ConsumerStatefulWidget {
  static const String id = '/home';

  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  final ScrollController _scrollController = ScrollController();
  List<PostModel> displayedPosts = [];
  final int _postsPerPage = 2;
  bool _isLoadingMore = false;
  bool _hasLoadedInitially = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final allPosts = ref.read(postProvider);
      if (allPosts.isNotEmpty && displayedPosts.isEmpty) {
        _hasLoadedInitially = true;
        _loadMorePosts();
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          !_isLoadingMore) {
        _loadMorePosts();
      }
    });
  }

  void _loadMorePosts() async {
    final allPosts = ref.read(postProvider);

    if (displayedPosts.length >= allPosts.length) return;

    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 1));

    final nextPosts =
        allPosts.skip(displayedPosts.length).take(_postsPerPage).toList();

    setState(() {
      displayedPosts.addAll(nextPosts);
      _isLoadingMore = false;
    });

    // auto-load rest for initial animation feel
    if (displayedPosts.length < allPosts.length) {
      _loadMorePosts();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allPosts = ref.watch(postProvider);
    final visiblePosts = allPosts.take(displayedPosts.length).toList();

    // ✅ Listen to changes inside build()
    ref.listen<List<PostModel>>(postProvider, (previous, next) {
      if (!_hasLoadedInitially && next.isNotEmpty) {
        _hasLoadedInitially = true;
        _loadMorePosts();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          if (allPosts.isEmpty && displayedPosts.isEmpty)
            const Center(child: CircularProgressIndicator())
          else
            ListView.builder(
              controller: _scrollController,
              itemCount: visiblePosts.length + 1,
              itemBuilder: (context, index) {
                if (index < visiblePosts.length) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: PostCard(post: visiblePosts[index]
                    ),
                  );
                } else {
                  return _isLoadingMore
                      ? const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox();
                }
              },
            ),
          Positioned(
            bottom: 60,
            right: 20,
            child: Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              elevation: 6,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreatePostScreen(),
                    ),
                  );
                },
                customBorder: const CircleBorder(),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child:
                      const Icon(Icons.message, color: Colors.white, size: 28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
