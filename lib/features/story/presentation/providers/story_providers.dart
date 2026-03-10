import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:talk/features/story/domain/entities/story.dart';

/// 剧情状态
class StoryState {
  final List<StoryChapter> chapters;
  final bool isLoading;

  const StoryState({
    this.chapters = const [],
    this.isLoading = false,
  });
}

/// 剧情状态管理
class StoryNotifier extends StateNotifier<StoryState> {
  StoryNotifier() : super(const StoryState());

  Future<void> loadChapters() async {}

  void completeChapter(String chapterId) {
    final updated = state.chapters.map((c) {
      if (c.id == chapterId) {
        return c.copyWith(isCompleted: true);
      }
      return c;
    }).toList();

    state = StoryState(chapters: updated);
  }
}

/// 剧情 Provider
final storyProvider =
    StateNotifierProvider<StoryNotifier, StoryState>(
  (ref) => StoryNotifier(),
);
