import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../const.dart';

S extractAsyncValue<T, S>(AsyncValue<T> asyncValue, S whenNotNull(T val), S whenNull, {S? whenLoading, S? whenError, S? whenOther}) {
  return switch(asyncValue) {
      AsyncData(value: final value) => value == null ? whenNull : whenNotNull(value),
      AsyncLoading() => whenLoading != null ? whenLoading : whenNull,
      AsyncError(error: final error, stackTrace: final stackTrace) => whenError != null ? whenError : whenNull,
      _ => whenOther != null ? whenOther : whenNull,
    };
}

void showPostDialog(WidgetRef ref, BuildContext context, String dialogTitle, void onPressed(WidgetRef ref, BuildContext ctx, String sendText)) {
  var _textToSend = '';

  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, _, __) => Material(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(dialogTitle),
            TextField(
              onChanged: (value) {
                _textToSend = value;
              },
            ),
            ElevatedButton(
              onPressed: () {
                 onPressed(ref, ctx, _textToSend);
              },
              child: const Text('send!'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('go back'),
            ),
          ],
        ),
      ),
    ),
  );
}

Map<String, List<List<String>>> extractEAndPtags(List<List<String>> tags) {
  var eTags = tags.where((element) => element[0] == "e").toList();
  var pTags = tags.where((element) => element[0] == "p").toList();
  return {
    "e": eTags,
    "p": pTags,
  };
}

POST_KIND classifyPostKind(List<List<String>> tags) {
  var eTags = tags.where((element) => element[0] == "e").toList();
  var pTags = tags.where((element) => element[0] == "p").toList();
  if (eTags.isNotEmpty && pTags.isNotEmpty) {
    var mentionTag = eTags.firstWhere((element) => element[3] == "mention", orElse: () => ["","","",""]);
    if (mentionTag[3] == "mention") {
      return POST_KIND.QUOTE_REPOST;
    }else{
      return POST_KIND.REPLY;
    }
  } else if (pTags.isNotEmpty) {
    return POST_KIND.MENTION;
  } else if (eTags.isNotEmpty) {
    print("invalidate post event found");
    print(eTags);
    return POST_KIND.INVALID;
  }
  else {
    return POST_KIND.NORMAL;
  }
}