import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

extension TextEx on Text {
  RichText urlToLink(
    BuildContext context,
  ) {
    final textSpans = <InlineSpan>[];
    final RegExp _urlReg = RegExp(
      r'https?://([\w-]+\.)+[\w-]+(/[\w-./?%&=#]*)?',
    );

    data!.splitMapJoin(
      _urlReg,
      onMatch: (Match match) {
        final _match = match[0] ?? '';
        textSpans.add(
          TextSpan(
            text: _match,
            style: const TextStyle(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () async => await launchUrlString(
                    Uri.encodeFull(_match),
                    mode: LaunchMode.externalApplication,
                  ),
          ),
        );
        return '';
      },
      onNonMatch: (String text) {
        textSpans.add(
          TextSpan(
            text: text,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        );
        return '';
      },
    );

    return RichText(text: TextSpan(children: textSpans));
  }
}
