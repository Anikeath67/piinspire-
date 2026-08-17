import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../providers.dart';
import '../widgets/pin_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.pixels >= controller.position.maxScrollExtent - 700) {
        ref.read(feedProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final feed = ref.watch(feedProvider);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => ref.read(feedProvider.notifier).refreshFeed(),
        child: CustomScrollView(
          controller: controller,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            const SliverAppBar(
              floating: true,
              snap: true,
              title: Text('Pinspire', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -1)),
            ),
            feed.when(
              loading: () => const SliverToBoxAdapter(child: _LoadingGrid()),
              error: (error, _) => SliverFillRemaining(
                child: Center(child: Text('Could not load images\n$error', textAlign: TextAlign.center)),
              ),
              data: (pins) => SliverPadding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 24),
                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 8,
                  childCount: pins.length,
                  itemBuilder: (_, index) => PinCard(pin: pins[index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 8,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        itemBuilder: (_, i) => Container(
          height: i.isEven ? 260 : 180,
          decoration: BoxDecoration(color: const Color(0xFFEDEDED), borderRadius: BorderRadius.circular(18)),
        ),
      ),
    );
  }
}
