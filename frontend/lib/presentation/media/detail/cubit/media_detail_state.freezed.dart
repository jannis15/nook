// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MediaDetailState {

 Media? get media; bool get isLoading; MediaFailure? get failure; bool get isHudVisible; bool get isHudClickMode; bool get isInfoVisible;
/// Create a copy of MediaDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaDetailStateCopyWith<MediaDetailState> get copyWith => _$MediaDetailStateCopyWithImpl<MediaDetailState>(this as MediaDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaDetailState&&(identical(other.media, media) || other.media == media)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isHudVisible, isHudVisible) || other.isHudVisible == isHudVisible)&&(identical(other.isHudClickMode, isHudClickMode) || other.isHudClickMode == isHudClickMode)&&(identical(other.isInfoVisible, isInfoVisible) || other.isInfoVisible == isInfoVisible));
}


@override
int get hashCode => Object.hash(runtimeType,media,isLoading,failure,isHudVisible,isHudClickMode,isInfoVisible);

@override
String toString() {
  return 'MediaDetailState(media: $media, isLoading: $isLoading, failure: $failure, isHudVisible: $isHudVisible, isHudClickMode: $isHudClickMode, isInfoVisible: $isInfoVisible)';
}


}

/// @nodoc
abstract mixin class $MediaDetailStateCopyWith<$Res>  {
  factory $MediaDetailStateCopyWith(MediaDetailState value, $Res Function(MediaDetailState) _then) = _$MediaDetailStateCopyWithImpl;
@useResult
$Res call({
 Media? media, bool isLoading, MediaFailure? failure, bool isHudVisible, bool isHudClickMode, bool isInfoVisible
});




}
/// @nodoc
class _$MediaDetailStateCopyWithImpl<$Res>
    implements $MediaDetailStateCopyWith<$Res> {
  _$MediaDetailStateCopyWithImpl(this._self, this._then);

  final MediaDetailState _self;
  final $Res Function(MediaDetailState) _then;

/// Create a copy of MediaDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? media = freezed,Object? isLoading = null,Object? failure = freezed,Object? isHudVisible = null,Object? isHudClickMode = null,Object? isInfoVisible = null,}) {
  return _then(_self.copyWith(
media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as Media?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as MediaFailure?,isHudVisible: null == isHudVisible ? _self.isHudVisible : isHudVisible // ignore: cast_nullable_to_non_nullable
as bool,isHudClickMode: null == isHudClickMode ? _self.isHudClickMode : isHudClickMode // ignore: cast_nullable_to_non_nullable
as bool,isInfoVisible: null == isInfoVisible ? _self.isInfoVisible : isInfoVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaDetailState].
extension MediaDetailStatePatterns on MediaDetailState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaDetailState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaDetailState value)  $default,){
final _that = this;
switch (_that) {
case _MediaDetailState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _MediaDetailState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Media? media,  bool isLoading,  MediaFailure? failure,  bool isHudVisible,  bool isHudClickMode,  bool isInfoVisible)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaDetailState() when $default != null:
return $default(_that.media,_that.isLoading,_that.failure,_that.isHudVisible,_that.isHudClickMode,_that.isInfoVisible);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Media? media,  bool isLoading,  MediaFailure? failure,  bool isHudVisible,  bool isHudClickMode,  bool isInfoVisible)  $default,) {final _that = this;
switch (_that) {
case _MediaDetailState():
return $default(_that.media,_that.isLoading,_that.failure,_that.isHudVisible,_that.isHudClickMode,_that.isInfoVisible);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Media? media,  bool isLoading,  MediaFailure? failure,  bool isHudVisible,  bool isHudClickMode,  bool isInfoVisible)?  $default,) {final _that = this;
switch (_that) {
case _MediaDetailState() when $default != null:
return $default(_that.media,_that.isLoading,_that.failure,_that.isHudVisible,_that.isHudClickMode,_that.isInfoVisible);case _:
  return null;

}
}

}

/// @nodoc


class _MediaDetailState extends MediaDetailState {
  const _MediaDetailState({this.media, this.isLoading = true, this.failure, this.isHudVisible = false, this.isHudClickMode = false, this.isInfoVisible = false}): super._();


@override final  Media? media;
@override@JsonKey() final  bool isLoading;
@override final  MediaFailure? failure;
@override@JsonKey() final  bool isHudVisible;
@override@JsonKey() final  bool isHudClickMode;
@override@JsonKey() final  bool isInfoVisible;

/// Create a copy of MediaDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaDetailStateCopyWith<_MediaDetailState> get copyWith => __$MediaDetailStateCopyWithImpl<_MediaDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaDetailState&&(identical(other.media, media) || other.media == media)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.isHudVisible, isHudVisible) || other.isHudVisible == isHudVisible)&&(identical(other.isHudClickMode, isHudClickMode) || other.isHudClickMode == isHudClickMode)&&(identical(other.isInfoVisible, isInfoVisible) || other.isInfoVisible == isInfoVisible));
}


@override
int get hashCode => Object.hash(runtimeType,media,isLoading,failure,isHudVisible,isHudClickMode,isInfoVisible);

@override
String toString() {
  return 'MediaDetailState(media: $media, isLoading: $isLoading, failure: $failure, isHudVisible: $isHudVisible, isHudClickMode: $isHudClickMode, isInfoVisible: $isInfoVisible)';
}


}

/// @nodoc
abstract mixin class _$MediaDetailStateCopyWith<$Res> implements $MediaDetailStateCopyWith<$Res> {
  factory _$MediaDetailStateCopyWith(_MediaDetailState value, $Res Function(_MediaDetailState) _then) = __$MediaDetailStateCopyWithImpl;
@override @useResult
$Res call({
 Media? media, bool isLoading, MediaFailure? failure, bool isHudVisible, bool isHudClickMode, bool isInfoVisible
});




}
/// @nodoc
class __$MediaDetailStateCopyWithImpl<$Res>
    implements _$MediaDetailStateCopyWith<$Res> {
  __$MediaDetailStateCopyWithImpl(this._self, this._then);

  final _MediaDetailState _self;
  final $Res Function(_MediaDetailState) _then;

/// Create a copy of MediaDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? media = freezed,Object? isLoading = null,Object? failure = freezed,Object? isHudVisible = null,Object? isHudClickMode = null,Object? isInfoVisible = null,}) {
  return _then(_MediaDetailState(
media: freezed == media ? _self.media : media // ignore: cast_nullable_to_non_nullable
as Media?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as MediaFailure?,isHudVisible: null == isHudVisible ? _self.isHudVisible : isHudVisible // ignore: cast_nullable_to_non_nullable
as bool,isHudClickMode: null == isHudClickMode ? _self.isHudClickMode : isHudClickMode // ignore: cast_nullable_to_non_nullable
as bool,isInfoVisible: null == isInfoVisible ? _self.isInfoVisible : isInfoVisible // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
