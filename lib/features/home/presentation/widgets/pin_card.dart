import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/pin_image.dart';
import '../../../../shared/models/pin.dart';
import '../../providers.dart';

class PinCard extends ConsumerWidget {
  final Pin pin;
  const PinCard({super.key, required this.pin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(savedPinsProvider).contains(pin.id);
    return GestureDetector(
      onTap: () => context.push('/home/pin/${pin.id}', extra: pin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: 'pin-${pin.id}',
                child: AspectRatio(
                  aspectRatio: pin.aspectRatio,
                  child: PinImage(url: pin.imageUrl),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Material(
                  color: saved ? AppTheme.red : Colors.white,
                  shape: const StadiumBorder(),
                  child: InkWell(
                    customBorder: const StadiumBorder(),
                    onTap: () => ref.read(savedPinsProvider.notifier).toggle(pin.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        child: Text(
                          saved ? 'Saved' : 'Save',
                          key: ValueKey(saved),
                          style: TextStyle(
                            color: saved ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            pin.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, height: 1.15),
          ),
          const SizedBox(height: 4),
          Text(pin.creator, style: const TextStyle(fontSize: 12, color: AppTheme.muted)),
        ],
      ),
    );
  }
}
