import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialfeedplus_parvathi/models/comments.dart';
import 'package:socialfeedplus_parvathi/models/post.dart';
import 'package:socialfeedplus_parvathi/notifier/posts_provider.dart';
import 'package:socialfeedplus_parvathi/services/ai_service.dart';


class CreatePostScreen extends ConsumerStatefulWidget {
  final bool? isComment;
  final int? postId;
  const CreatePostScreen({super.key, this.isComment, this.postId});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ImagePicker picker = ImagePicker();
  String? image;
  XFile? pickedFile;
  bool isImagePicked = false;
  bool isTextFieldEmpty = true;
  bool isLoadingCaption = false;
  bool _isDisposed = false;
  String? username;
  String? name;
  late SharedPreferences prefs;
  bool isPosting = false;
  bool isTypingCaption = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    _loadSharedPreferences();

    _controller.addListener(() {
      final isEmpty = _controller.text.trim().isEmpty;
      if (isEmpty != isTextFieldEmpty) {
        setState(() {
          isTextFieldEmpty = isEmpty;
        });
      }
    });
  }

  Future<void> _loadSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
    username = prefs.getString('username');
    name = prefs.getString('username');

    debugPrint(
        'Loaded from SharedPreferences -> username: $username, name: $name');
  }

  Future<void> _generateAICaption() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();
    if (!mounted) return;

    setState(() {
      isLoadingCaption = true;
      isTypingCaption = false; // reset before generating
    });

    final quote = await AIService.fetchCaption();
    if (!mounted) return;

    setState(() => isLoadingCaption = false);

    if (quote != null) {
      _controller.clear();
      final text = '${quote.quote}\n\n- ${quote.author}';

      setState(() => isTypingCaption = true);

      // Typewriter effect
      for (int i = 0; i < text.length; i++) {
        if (_isDisposed) return;
        await Future.delayed(const Duration(milliseconds: 40));
        if (_isDisposed) return;

        // Append one character at a time
        _controller.text = _controller.text + text[i];
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }

      if (!mounted) return;
      setState(() => isTypingCaption = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✨ Caption generated'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch caption.')),
      );
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 14, top: 10, bottom: 5),
              child: ElevatedButton(
                onPressed: () async {
                  if (isTextFieldEmpty || isLoadingCaption) return;
                  setState(() => isPosting = true);
                  final now = DateTime.now();
                  final formattedTime = DateFormat('h:mm a').format(now);
                  final formattedDate = DateFormat('d MMMM, yyyy').format(now);
                  if (widget.isComment == true && widget.postId != null) {
                    final newComment = CommentModel(
                      commentId: DateTime.now().millisecondsSinceEpoch,
                      name: name ?? 'Anonymous',
                      username: username ?? '@user',
                      text: _controller.text.trim(),
                      date: formattedDate,
                      time: formattedTime,
                    );

                    ref
                        .read(postProvider.notifier)
                        .addComment(widget.postId!, newComment);
                  } else {
                    final newPost = PostModel(
                      postId: ref.read(postProvider).length + 1,
                      name: name ?? 'name not defined',
                      username: username ?? 'username',
                      date: formattedDate,
                      time: formattedTime,
                      likes: 0,
                      caption: _controller.text.trim(),
                      commentCount: 0,
                      imagePath: image,
                      profileImage: null,
                    );
                    await Future.delayed(const Duration(seconds: 2));

                    ref.read(postProvider.notifier).addPost(newPost);
                  }

                  setState(() => isPosting = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(widget.isComment == true
                          ? 'Comment added successfully 💬'
                          : 'Post added successfully 🎉'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isTextFieldEmpty || isLoadingCaption || isTypingCaption
                          ? Colors.grey.withOpacity(0.1)
                          : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
                child: const Text(
                  "Post",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(top: 14, left: 10, right: 10),
              margin: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage("assets/images/boy.png"),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: TextField(
                            controller: _controller,
                            focusNode: _focusNode,
                            autofocus: true,
                            maxLines: null,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              hintText: "Enter caption here",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (isImagePicked) ...[
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        File(image!),
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],

                  const SizedBox(height: 30),

                  // 'Generate AI Caption' Button
                  InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      if (isLoadingCaption) return;
                      debugPrint('---------$isLoadingCaption----------');
                      _generateAICaption();
                    },
                    child: Container(
                      padding: const EdgeInsets.only(
                          top: 8, left: 12, right: 16, bottom: 9),
                      decoration: BoxDecoration(
                        color: const Color(0xff6F8EFC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: 50,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/ai-pencil.png',
                            height: 25,
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 9),
                            child: const Text(
                              'Generate Caption with AI',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(height: 20),
                  if (isLoadingCaption || isTypingCaption)
                    LinearProgressIndicator(
                      color: isTypingCaption
                          ? const Color(0xff6F8EFC)
                          : Colors.pink.shade200,
                      backgroundColor: Colors.grey.shade100,
                      minHeight: 6,
                    ),

                  // Add image button
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image_outlined,
                            color: Colors.blue),
                        onPressed: () async {
                          try {
                            PermissionStatus cameraStatus =
                                await Permission.camera.request();
                            PermissionStatus storageStatus =
                                await Permission.storage.request();
                            if (cameraStatus.isGranted ||
                                storageStatus.isGranted) {
                              pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery);
                              image = pickedFile!.path;
                              setState(() {
                                isImagePicked = true;
                              });
                            } else if (cameraStatus.isDenied) {
                              openAppSettings();
                            }
                          } catch (err) {
                            debugPrint('--------- $err -------');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isPosting)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent),
                ),
              ),
          ],
        ));
  }
}
