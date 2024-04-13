import 'package:flutter_riverpod/flutter_riverpod.dart';

S extractAsyncValue<T, S>(AsyncValue<T> asyncValue, S whenNotNull(T val), S whenNull, {S? whenLoading, S? whenError, S? whenOther}) {
  return switch(asyncValue) {
      AsyncData(value: final value) => value == null ? whenNull : whenNotNull(value),
      AsyncLoading() => whenLoading != null ? whenLoading : whenNull,
      AsyncError(error: final error, stackTrace: final stackTrace) => whenError != null ? whenError : whenNull,
      _ => whenOther != null ? whenOther : whenNull,
    };
}