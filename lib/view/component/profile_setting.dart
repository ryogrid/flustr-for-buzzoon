import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../external/np2p_api.dart';
import '../component/section.dart';

class ProfileSetting extends ConsumerWidget {
  ProfileSetting(
      {Key? key,
        required this.url,
        required this.pubHex,
        required this.secHex,
        required this.name,
        required this.about,
        required this.picture})
      : super(key: key);

  String url;
  String pubHex;
  String secHex;
  String name;
  String about;
  String picture;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Center(
          child: const Section(
            title: 'Profile Setting',
            content: [],
          ),
        ),
        const SizedBox(height: 60),
        Align(
          alignment: Alignment.centerLeft,
          child: Section(
            title: 'name',
            content: [
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      initialValue: this.name,
                      onChanged: (value) {
                        this.name = value;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.centerLeft,
          child: Section(
            title: 'about',
            content: [
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      initialValue: this.about,
                      onChanged: (value) {
                        this.about = value;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 30),
        Align(
          alignment: Alignment.centerLeft,
          child: Section(
            title: 'picture (url)',
            content: [
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      initialValue: this.picture,
                      onChanged: (value) {
                        this.picture = value;
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Center(
          child: ElevatedButton(
            onPressed: () {
              final trimmedName = this.name.trim();
              final trimmedAbout = this.about.trim();
              final trimmedPicture = this.picture.trim();
              Np2pAPI.publishProfile(this.url, this.pubHex, this.secHex, trimmedName,
                  trimmedAbout, trimmedPicture);
            },
            child: const Text('save'),
          ),
        ),
      ],
    );
  }
}
