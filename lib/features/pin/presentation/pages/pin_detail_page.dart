import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/pin_image.dart';
import '../../../../shared/models/pin.dart';
import '../../../home/providers.dart';

class PinDetailPage extends ConsumerWidget {
  final String pinId;
  final Pin? initialPin;

  const PinDetailPage({super.key, required this.pinId, this.initialPin});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pin = initialPin;
    if (pin == null) {
      return const Scaffold(body: Center(child: Text('Pin not found')));
    }
    final saved = ref.watch(savedPinsProvider).contains(pin.id);
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
            actions: [
              IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
              IconButton(icon: const Icon(Icons.more_horiz), onPressed: () {}),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Hero(tag: 'pin-${pin.id}', child: PinImage(url: pin.imageUrl, borderRadius: BorderRadius.zero)),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 30),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(pin.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w800, height: 1.1)),
                  const SizedBox(height: 10),
                  Text(pin.description, style: const TextStyle(fontSize: 15, height: 1.4)),
                  const SizedBox(height: 20),
                  Row(children: [
                    const CircleAvatar(radius: 22, child: Icon(Icons.person)),
                    const SizedBox(width: 10),
                    Expanded(child: Text(pin.creator, style: const TextStyle(fontWeight: FontWeight.w700))),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: saved ? AppTheme.red : Colors.black),
                      onPressed: () => ref.read(savedPinsProvider.notifier).toggle(pin.id),
                      child: Text(saved ? 'Saved' : 'Save'),
                    ),
                  ]),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => launchUrl(Uri.parse(pin.photoUrl), mode: LaunchMode.externalApplication),
                    icon: const Icon(Icons.open_in_new, size: 17),
                    label: Text('Photo by ${pin.creator} on Pexels'),
                  ),
                ]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
