// lib/features/upload/presentation/new_post_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweater/features/upload/controllers/upload_post_controller.dart';

class NewPostPage extends ConsumerStatefulWidget {
  const NewPostPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPostPageState();
}

class _NewPostPageState extends ConsumerState<NewPostPage> {
  final _textCtrl = TextEditingController();
  final _picker = ImagePicker();
  final _files = <File>[];

  /// 이미지 여러 장 선택
  Future<void> _pick() async {
    final imgs = await _picker.pickMultiImage(imageQuality: 85);
    if (imgs.isNotEmpty) {
      setState(() {
        _files.addAll(imgs.map((e) => File(e.path)));
      });
    }
  }

  /// 선택한 이미지 삭제
  void _removeImage(File file) {
    setState(() {
      _files.remove(file);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadPostControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('새 게시물'),
        actions: [
          TextButton(
            onPressed:
                state.isLoading || _files.isEmpty
                    ? null
                    : () async {
                      try {
                        await ref
                            .read(uploadPostControllerProvider.notifier)
                            .upload(
                              images: _files,
                              text:
                                  _textCtrl.text.trim().isEmpty
                                      ? null
                                      : _textCtrl.text.trim(),
                            );
                        if (!context.mounted) return;
                        Navigator.pop(context, true); // ← 여기서만 종료
                      } catch (e) {
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('업로드 실패: $e')));
                      }
                    },
            child:
                state.isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Text('공유'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 본문 입력창
          TextField(
            controller: _textCtrl,
            maxLines: null,
            decoration: const InputDecoration(
              hintText: '문구를 입력하세요...',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 12),

          // 이미지 미리보기
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final f in _files)
                Stack(
                  children: [
                    Image.file(f, width: 100, height: 100, fit: BoxFit.cover),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => _removeImage(f),
                        child: Container(
                          color: Colors.black54,
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              IconButton(
                onPressed: _pick,
                icon: const Icon(Icons.add_photo_alternate, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }
}
