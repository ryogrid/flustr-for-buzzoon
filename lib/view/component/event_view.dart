import 'package:nostrp2p/controller/profile_provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nostr/nostr.dart';
import 'package:intl/intl.dart';

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
              AsyncError(value: final authorProf) => Container(
                clipBehavior: Clip.antiAlias,
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  'https://image.nostr.build/fc9f5d58c897b303f468ec5e608a297a1068d3acf250a68c0b2b2d64933f1ab4.jpg',
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
                      AsyncError(:final error) => 'unknown',//error.toString(),
                      _ => "unkown",
                    },
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(event.content),
                  Align(
                    child: Text(event.pubkey.substring(0, 9) + "..."),
                    alignment: Alignment.centerRight,
                  ),
                  Align(
                    child: Text(DateFormat.Md().add_jm().format(
                        DateTime.fromMillisecondsSinceEpoch(
                            event.createdAt * 1000))),
                    alignment: Alignment.centerRight,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
