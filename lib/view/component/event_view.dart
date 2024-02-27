import 'package:buzzoon/controller/profile_provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr/nostr.dart';

class EventView extends ConsumerWidget {
  const EventView({Key? key, required this.event}) : super(key: key);

  final Event event;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final author = ref.watch(profileProvider(event.pubkey));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            switch (author) {
              AsyncData(value: final authorProf) => Container(
                  clipBehavior: Clip.antiAlias,
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(
                    authorProf.picture,
                  ),
                ),
              _ => const SizedBox(),
            },
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    switch (author) {
                      AsyncData(value: final authorProf) => authorProf.name,
                      AsyncLoading() => 'loading',
                      AsyncError(:final error) =>
                        error.toString(),
                        _ => "aaa",
                    },
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(event.content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
