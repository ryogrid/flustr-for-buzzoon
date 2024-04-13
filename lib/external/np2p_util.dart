import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

S extractAsyncValue<T, S>(AsyncValue<T> asyncValue, S whenNotNull(T val), S whenNull, {S? whenLoading, S? whenError, S? whenOther}) {
  return switch(asyncValue) {
      AsyncData(value: final value) => value == null ? whenNull : whenNotNull(value),
      AsyncLoading() => whenLoading != null ? whenLoading : whenNull,
      AsyncError(error: final error, stackTrace: final stackTrace) => whenError != null ? whenError : whenNull,
      _ => whenOther != null ? whenOther : whenNull,
    };
}

void showPostDialog(WidgetRef ref, BuildContext context, void onPressed(WidgetRef ref, BuildContext ctx, String sendText)) {
  var _textToSend = '';

  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, _, __) => Material(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('send text event'),
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