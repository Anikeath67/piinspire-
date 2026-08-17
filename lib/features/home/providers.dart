import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/pin.dart';
import 'data/home_repository.dart';

final homeRepositoryProvider = Provider<HomeRepository>(
  (ref) => HomeRepository(),
);

final feedProvider = AsyncNotifierProvider<FeedNotifier, List<Pin>>(
  FeedNotifier.new,
);

class FeedNotifier extends AsyncNotifier<List<Pin>> {
  int _page = 1;
  bool _loadingMore = false;

  @override
  Future<List<Pin>> build() async {
    _page = 1;
    return ref.read(homeRepositoryProvider).getHomeFeed(page: _page);
  }

  Future<void> refreshFeed() async {
    _page = 1;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(homeRepositoryProvider).getHomeFeed(page: _page),
    );
  }

  Future<void> loadMore() async {
    if (_loadingMore || !state.hasValue) return;

    _loadingMore = true;
    try {
      final nextPage = _page + 1;
      final more = await ref
          .read(homeRepositoryProvider)
          .getHomeFeed(page: nextPage);

      if (more.isNotEmpty) {
        _page = nextPage;
        state = AsyncData([...state.value!, ...more]);
      }
    } catch (_) {
      // Keep existing content visible when pagination fails.
    } finally {
      _loadingMore = false;
    }
  }
}

final searchPinsProvider = FutureProvider.family<List<Pin>, String>(
  (ref, query) => ref.read(homeRepositoryProvider).search(query),
);

final savedPinsProvider = NotifierProvider<SavedPinsNotifier, Set<String>>(
  SavedPinsNotifier.new,
);

class SavedPinsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  void toggle(String id) {
    final next = {...state};
    if (!next.add(id)) next.remove(id);
    state = next;
  }
}
