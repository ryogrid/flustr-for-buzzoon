// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'servaddr_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ServAddrSetting _$ServAddrSettingFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'servAddr':
      return ImplServAddrSetting.fromJson(json);
    case 'empty':
      return EmptyServAddrSetting.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'ServAddrSetting',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$ServAddrSetting {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String servAddr) servAddr,
    required TResult Function() empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String servAddr)? servAddr,
    TResult? Function()? empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String servAddr)? servAddr,
    TResult Function()? empty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImplServAddrSetting value) servAddr,
    required TResult Function(EmptyServAddrSetting value) empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImplServAddrSetting value)? servAddr,
    TResult? Function(EmptyServAddrSetting value)? empty,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImplServAddrSetting value)? servAddr,
    TResult Function(EmptyServAddrSetting value)? empty,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServAddrSettingCopyWith<$Res> {
  factory $ServAddrSettingCopyWith(
          ServAddrSetting value, $Res Function(ServAddrSetting) then) =
      _$ServAddrSettingCopyWithImpl<$Res, ServAddrSetting>;
}

/// @nodoc
class _$ServAddrSettingCopyWithImpl<$Res, $Val extends ServAddrSetting>
    implements $ServAddrSettingCopyWith<$Res> {
  _$ServAddrSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$ImplServAddrSettingImplCopyWith<$Res> {
  factory _$$ImplServAddrSettingImplCopyWith(_$ImplServAddrSettingImpl value,
          $Res Function(_$ImplServAddrSettingImpl) then) =
      __$$ImplServAddrSettingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String servAddr});
}

/// @nodoc
class __$$ImplServAddrSettingImplCopyWithImpl<$Res>
    extends _$ServAddrSettingCopyWithImpl<$Res, _$ImplServAddrSettingImpl>
    implements _$$ImplServAddrSettingImplCopyWith<$Res> {
  __$$ImplServAddrSettingImplCopyWithImpl(_$ImplServAddrSettingImpl _value,
      $Res Function(_$ImplServAddrSettingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? servAddr = null,
  }) {
    return _then(_$ImplServAddrSettingImpl(
      servAddr: null == servAddr
          ? _value.servAddr
          : servAddr // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ImplServAddrSettingImpl extends ImplServAddrSetting {
  _$ImplServAddrSettingImpl({required this.servAddr, final String? $type})
      : $type = $type ?? 'servAddr',
        super._();

  factory _$ImplServAddrSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$ImplServAddrSettingImplFromJson(json);

  @override
  final String servAddr;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ServAddrSetting.servAddr(servAddr: $servAddr)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ImplServAddrSettingImpl &&
            (identical(other.servAddr, servAddr) ||
                other.servAddr == servAddr));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, servAddr);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ImplServAddrSettingImplCopyWith<_$ImplServAddrSettingImpl> get copyWith =>
      __$$ImplServAddrSettingImplCopyWithImpl<_$ImplServAddrSettingImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String servAddr) servAddr,
    required TResult Function() empty,
  }) {
    return servAddr(this.servAddr);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String servAddr)? servAddr,
    TResult? Function()? empty,
  }) {
    return servAddr?.call(this.servAddr);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String servAddr)? servAddr,
    TResult Function()? empty,
    required TResult orElse(),
  }) {
    if (servAddr != null) {
      return servAddr(this.servAddr);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImplServAddrSetting value) servAddr,
    required TResult Function(EmptyServAddrSetting value) empty,
  }) {
    return servAddr(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImplServAddrSetting value)? servAddr,
    TResult? Function(EmptyServAddrSetting value)? empty,
  }) {
    return servAddr?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImplServAddrSetting value)? servAddr,
    TResult Function(EmptyServAddrSetting value)? empty,
    required TResult orElse(),
  }) {
    if (servAddr != null) {
      return servAddr(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ImplServAddrSettingImplToJson(
      this,
    );
  }
}

abstract class ImplServAddrSetting extends ServAddrSetting {
  factory ImplServAddrSetting({required final String servAddr}) =
      _$ImplServAddrSettingImpl;
  ImplServAddrSetting._() : super._();

  factory ImplServAddrSetting.fromJson(Map<String, dynamic> json) =
      _$ImplServAddrSettingImpl.fromJson;

  String get servAddr;
  @JsonKey(ignore: true)
  _$$ImplServAddrSettingImplCopyWith<_$ImplServAddrSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EmptyServAddrSettingImplCopyWith<$Res> {
  factory _$$EmptyServAddrSettingImplCopyWith(_$EmptyServAddrSettingImpl value,
          $Res Function(_$EmptyServAddrSettingImpl) then) =
      __$$EmptyServAddrSettingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$EmptyServAddrSettingImplCopyWithImpl<$Res>
    extends _$ServAddrSettingCopyWithImpl<$Res, _$EmptyServAddrSettingImpl>
    implements _$$EmptyServAddrSettingImplCopyWith<$Res> {
  __$$EmptyServAddrSettingImplCopyWithImpl(_$EmptyServAddrSettingImpl _value,
      $Res Function(_$EmptyServAddrSettingImpl) _then)
      : super(_value, _then);
}

/// @nodoc
@JsonSerializable()
class _$EmptyServAddrSettingImpl extends EmptyServAddrSetting {
  _$EmptyServAddrSettingImpl({final String? $type})
      : $type = $type ?? 'empty',
        super._();

  factory _$EmptyServAddrSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$EmptyServAddrSettingImplFromJson(json);

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ServAddrSetting.empty()';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EmptyServAddrSettingImpl);
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String servAddr) servAddr,
    required TResult Function() empty,
  }) {
    return empty();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String servAddr)? servAddr,
    TResult? Function()? empty,
  }) {
    return empty?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String servAddr)? servAddr,
    TResult Function()? empty,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(ImplServAddrSetting value) servAddr,
    required TResult Function(EmptyServAddrSetting value) empty,
  }) {
    return empty(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(ImplServAddrSetting value)? servAddr,
    TResult? Function(EmptyServAddrSetting value)? empty,
  }) {
    return empty?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(ImplServAddrSetting value)? servAddr,
    TResult Function(EmptyServAddrSetting value)? empty,
    required TResult orElse(),
  }) {
    if (empty != null) {
      return empty(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$EmptyServAddrSettingImplToJson(
      this,
    );
  }
}

abstract class EmptyServAddrSetting extends ServAddrSetting {
  factory EmptyServAddrSetting() = _$EmptyServAddrSettingImpl;
  EmptyServAddrSetting._() : super._();

  factory EmptyServAddrSetting.fromJson(Map<String, dynamic> json) =
      _$EmptyServAddrSettingImpl.fromJson;
}
