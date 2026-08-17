import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../home/providers.dart';
import '../../../../core/widgets/pin_image.dart';
import '../../../../shared/models/pin.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final feedAsync = ref.watch(feedProvider);
    final savedIds = ref.watch(savedPinsProvider);

    final List<Pin> pins =
        feedAsync.asData?.value ?? <Pin>[];

    final List<Pin> savedPins = pins
        .where((pin) => savedIds.contains(pin.id))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),

          slivers: [

            // ==========================================================
            // PROFILE APP BAR
            // ==========================================================

            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,

              automaticallyImplyLeading: false,

              titleSpacing: 20,

              title: const Text(
                'Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),

              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Colors.black,
                    size: 27,
                  ),
                ),

                const SizedBox(width: 8),
              ],
            ),

            // ==========================================================
            // PROFILE HEADER
            // ==========================================================

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  0,
                ),

                child: Column(
                  children: [

                    // PROFILE IMAGE
                    const CircleAvatar(
                      radius: 52,
                      backgroundColor: Color(0xFFE9E9E9),

                      backgroundImage: NetworkImage(
                        'https://i.pravatar.cc/300?img=12',
                      ),
                    ),

                    const SizedBox(height: 14),

                    // NAME
                    const Text(
                      'Your Profile',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // USERNAME
                    const Text(
                      '@pinspire_user',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // EDIT PROFILE
                    SizedBox(
                      height: 44,

                      child: FilledButton(
                        onPressed: () {},

                        style: FilledButton.styleFrom(
                          backgroundColor:
                              const Color(0xFFE9E9E9),

                          foregroundColor: Colors.black,

                          elevation: 0,

                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 24,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(24),
                          ),
                        ),

                        child: const Text(
                          'Edit profile',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // ==================================================
                    // STATS
                    // ==================================================

                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,

                      children: [

                        const _ProfileCounter(
                          value: '128',
                          label: 'Followers',
                        ),

                        const _ProfileCounter(
                          value: '96',
                          label: 'Following',
                        ),

                        _ProfileCounter(
                          value: '${savedIds.length}',
                          label: 'Saved',
                        ),
                      ],
                    ),

                    const SizedBox(height: 26),
                  ],
                ),
              ),
            ),

            // ==========================================================
            // CREATED / SAVED TAB BAR
            // ==========================================================

            SliverPersistentHeader(
              pinned: true,

              delegate:
                  _ProfileTabHeaderDelegate(
                selectedTab: selectedTab,

                onChanged: (index) {
                  setState(() {
                    selectedTab = index;
                  });
                },
              ),
            ),

            // ==========================================================
            // CREATED TAB
            // COMPLETELY BLANK
            // ==========================================================

            if (selectedTab == 0)

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 400,
                ),
              )

            // ==========================================================
            // SAVED TAB
            // ==========================================================

            else if (savedPins.isEmpty)

              const SliverFillRemaining(
                hasScrollBody: false,

                child: _EmptySavedPins(),
              )

            else

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  8,
                  12,
                  8,
                  30,
                ),

                sliver: SliverMasonryGrid.count(
                  crossAxisCount: 2,

                  mainAxisSpacing: 10,

                  crossAxisSpacing: 8,

                  childCount: savedPins.length,

                  itemBuilder: (
                    BuildContext context,
                    int index,
                  ) {
                    return _ProfilePinCard(
                      pin: savedPins[index],
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

// ======================================================================
// PROFILE COUNTER
// ======================================================================

class _ProfileCounter extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileCounter({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 95,

      child: Column(
        children: [

          Text(
            value,

            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,

            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================================
// CREATED / SAVED TAB HEADER
// ======================================================================

class _ProfileTabHeaderDelegate
    extends SliverPersistentHeaderDelegate {

  final int selectedTab;
  final ValueChanged<int> onChanged;

  const _ProfileTabHeaderDelegate({
    required this.selectedTab,
    required this.onChanged,
  });

  @override
  double get minExtent => 52;

  @override
  double get maxExtent => 52;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,

      child: Row(
        children: [

          // ============================================================
          // CREATED
          // ============================================================

          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,

              onTap: () {
                onChanged(0);
              },

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  Expanded(
                    child: Center(
                      child: Text(
                        'Created',

                        style: TextStyle(
                          color: selectedTab == 0
                              ? Colors.black
                              : Colors.black54,

                          fontSize: 16,

                          fontWeight:
                              selectedTab == 0
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 200,
                    ),

                    curve: Curves.easeOut,

                    width:
                        selectedTab == 0
                            ? 52
                            : 0,

                    height: 3,

                    decoration:
                        BoxDecoration(
                      color: Colors.black,

                      borderRadius:
                          BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================================================
          // SAVED
          // ============================================================

          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,

              onTap: () {
                onChanged(1);
              },

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end,

                children: [

                  Expanded(
                    child: Center(
                      child: Text(
                        'Saved',

                        style: TextStyle(
                          color: selectedTab == 1
                              ? Colors.black
                              : Colors.black54,

                          fontSize: 16,

                          fontWeight:
                              selectedTab == 1
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  AnimatedContainer(
                    duration:
                        const Duration(
                      milliseconds: 200,
                    ),

                    curve: Curves.easeOut,

                    width:
                        selectedTab == 1
                            ? 52
                            : 0,

                    height: 3,

                    decoration:
                        BoxDecoration(
                      color: Colors.black,

                      borderRadius:
                          BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(
    covariant _ProfileTabHeaderDelegate oldDelegate,
  ) {
    return oldDelegate.selectedTab != selectedTab;
  }
}

// ======================================================================
// SAVED PIN CARD
// ======================================================================

class _ProfilePinCard extends StatelessWidget {
  final Pin pin;

  const _ProfilePinCard({
    required this.pin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},

      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [

          ClipRRect(
            borderRadius:
                BorderRadius.circular(16),

            child: PinImage(
              url: pin.imageUrl,
            ),
          ),

          const SizedBox(height: 6),

          Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 2,
            ),

            child: Text(
              pin.title,

              maxLines: 2,

              overflow:
                  TextOverflow.ellipsis,

              style: const TextStyle(
                color: Colors.black,

                fontSize: 14,

                fontWeight:
                    FontWeight.w700,

                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================================
// EMPTY SAVED STATE
// ======================================================================

class _EmptySavedPins extends StatelessWidget {
  const _EmptySavedPins();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding:
            EdgeInsets.symmetric(
          horizontal: 35,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Icon(
              Icons.bookmark_border_rounded,

              size: 58,

              color: Colors.black45,
            ),

            SizedBox(height: 16),

            Text(
              'Nothing saved yet',

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.black,

                fontSize: 21,

                fontWeight:
                    FontWeight.w800,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Save Pins you love and they will appear here.',

              textAlign: TextAlign.center,

              style: TextStyle(
                color: Colors.black54,

                fontSize: 15,

                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}