import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../home/providers.dart';
import '../../../home/presentation/widgets/pin_card.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final controller = TextEditingController();
  String query = '';

  static const topics = [
    'Home decor',
    'Fashion',
    'Travel',
    'Food',
    'Cars',
    'Architecture',
    'Nature',
    'Art',
    'Fitness',
    'Photography',
  ];

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void submit(String value) {
    final next = value.trim();
    setState(() => query = next);
  }

  void selectTopic(String topic) {
    controller.text = topic;
    submit(topic);
  }

  @override
  Widget build(BuildContext context) {
    final result = query.isEmpty ? null : ref.watch(searchPinsProvider(query));

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            titleSpacing: 12,
            title: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: submit,
              decoration: InputDecoration(
                hintText: 'Search ideas, cars, fashion...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          controller.clear();
                          setState(() => query = '');
                        },
                      ),
                filled: true,
                fillColor: const Color(0xFFF1F1F1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (query.isEmpty)
            SliverToBoxAdapter(
              child: _Explore(onTopicSelected: selectTopic),
            )
          else
            result!.when(
              loading: () => const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      '$e',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              data: (pins) {
                if (pins.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No images found. Try another search.')),
                  );
                }
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 24),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 8,
                    childCount: pins.length,
                    itemBuilder: (_, index) => PinCard(pin: pins[index]),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _Explore extends StatelessWidget {
  final ValueChanged<String> onTopicSelected;

  const _Explore({required this.onTopicSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Explore',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _SearchPageState.topics
                .map(
                  (topic) => ActionChip(
                    label: Text(topic),
                    onPressed: () => onTopicSelected(topic),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
