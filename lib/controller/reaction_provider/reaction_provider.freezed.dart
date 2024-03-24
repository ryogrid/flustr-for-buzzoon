// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reaction_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ReactionData {
  String get eventId => throw _privateConstructorUsedError;
  List<String> get pubHexs => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReactionDataCopyWith<ReactionData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReactionDataCopyWith<$Res> {
  factory $ReactionDataCopyWith(
          ReactionData value, $Res Function(ReactionData) then) =
      _$ReactionDataCopyWithImpl<$Res, ReactionData>;
  @useResult
  $Res call({String eventId, List<String> pubHexs});
}

/// @nodoc
class _$ReactionDataCopyWithImpl<$Res, $Val extends ReactionData>
    implements $ReactionDataCopyWith<$Res> {
  _$ReactionDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? pubHexs = null,
  }) {
    return _then(_value.copyWith(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      pubHexs: null == pubHexs
          ? _value.pubHexs
          : pubHexs // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReactionDataImplCopyWith<$Res>
    implements $ReactionDataCopyWith<$Res> {
  factory _$$ReactionDataImplCopyWith(
          _$ReactionDataImpl value, $Res Function(_$ReactionDataImpl) then) =
      __$$ReactionDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String eventId, List<String> pubHexs});
}

/// @nodoc
class __$$ReactionDataImplCopyWithImpl<$Res>
    extends _$ReactionDataCopyWithImpl<$Res, _$ReactionDataImpl>
    implements _$$ReactionDataImplCopyWith<$Res> {
  __$$ReactionDataImplCopyWithImpl(
      _$ReactionDataImpl _value, $Res Function(_$ReactionDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? eventId = null,
    Object? pubHexs = null,
  }) {
    return _then(_$ReactionDataImpl(
      eventId: null == eventId
          ? _value.eventId
          : eventId // ignore: cast_nullable_to_non_nullable
              as String,
      pubHexs: null == pubHexs
          ? _value._pubHexs
          : pubHexs // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$ReactionDataImpl extends _ReactionData with DiagnosticableTreeMixin {
  _$ReactionDataImpl(
      {required this.eventId, required final List<String> pubHexs})
      : _pubHexs = pubHexs,
        super._();

  @override
  final String eventId;
  final List<String> _pubHexs;
  @override
  List<String> get pubHexs {
    if (_pubHexs is EqualUnmodifiableListView) return _pubHexs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pubHexs);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'ReactionData(eventId: $eventId, pubHexs: $pubHexs)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'ReactionData'))
      ..add(DiagnosticsProperty('eventId', eventId))
      ..add(DiagnosticsProperty('pubHexs', pubHexs));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReactionDataImpl &&
            (identical(other.eventId, eventId) || other.eventId == eventId) &&
            const DeepCollectionEquality().equals(other._pubHexs, _pubHexs));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, eventId, const DeepCollectionEquality().hash(_pubHexs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReactionDataImplCopyWith<_$ReactionDataImpl> get copyWith =>
      __$$ReactionDataImplCopyWithImpl<_$ReactionDataImpl>(this, _$identity);
}

abstract class _ReactionData extends ReactionData {
  factory _ReactionData(
      {required final String eventId,
      required final List<String> pubHexs}) = _$ReactionDataImpl;
  _ReactionData._() : super._();

  @override
  String get eventId;
  @override
  List<String> get pubHexs;
  @override
  @JsonKey(ignore: true)
  _$$ReactionDataImplCopyWith<_$ReactionDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
