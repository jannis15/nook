// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_media_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VideoMediaDetailState {

 bool get isLoading; bool get hasError; bool get areControlsVisible; bool get isPlaying; bool get isMuted;
/// Create a copy of VideoMediaDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoMediaDetailStateCopyWith<VideoMediaDetailState> get copyWith => _$VideoMediaDetailStateCopyWithImpl<VideoMediaDetailState>(this as VideoMediaDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoMediaDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.areControlsVisible, areControlsVisible) || other.areControlsVisible == areControlsVisible)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,areControlsVisible,isPlaying,isMuted);

@override
String toString() {
  return 'VideoMediaDetailState(isLoading: $isLoading, hasError: $hasError, areControlsVisible: $areControlsVisible, isPlaying: $isPlaying, isMuted: $isMuted)';
}


}

/// @nodoc
abstract mixin class $VideoMediaDetailStateCopyWith<$Res>  {
  factory $VideoMediaDetailStateCopyWith(VideoMediaDetailState value, $Res Function(VideoMediaDetailState) _then) = _$VideoMediaDetailStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, bool hasError, bool areControlsVisible, bool isPlaying, bool isMuted
});




}
/// @nodoc
class _$VideoMediaDetailStateCopyWithImpl<$Res>
    implements $VideoMediaDetailStateCopyWith<$Res> {
  _$VideoMediaDetailStateCopyWithImpl(this._self, this._then);

  final VideoMediaDetailState _self;
  final $Res Function(VideoMediaDetailState) _then;

/// Create a copy of VideoMediaDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? hasError = null,Object? areControlsVisible = null,Object? isPlaying = null,Object? isMuted = null,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,areControlsVisible: null == areControlsVisible ? _self.areControlsVisible : areControlsVisible // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoMediaDetailState].
extension VideoMediaDetailStatePatterns on VideoMediaDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoMediaDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoMediaDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoMediaDetailState value)  $default,){
final _that = this;
switch (_that) {
case _VideoMediaDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoMediaDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _VideoMediaDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  bool areControlsVisible,  bool isPlaying,  bool isMuted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoMediaDetailState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.areControlsVisible,_that.isPlaying,_that.isMuted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  bool hasError,  bool areControlsVisible,  bool isPlaying,  bool isMuted)  $default,) {final _that = this;
switch (_that) {
case _VideoMediaDetailState():
return $default(_that.isLoading,_that.hasError,_that.areControlsVisible,_that.isPlaying,_that.isMuted);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  bool hasError,  bool areControlsVisible,  bool isPlaying,  bool isMuted)?  $default,) {final _that = this;
switch (_that) {
case _VideoMediaDetailState() when $default != null:
return $default(_that.isLoading,_that.hasError,_that.areControlsVisible,_that.isPlaying,_that.isMuted);case _:
  return null;

}
}

}

/// @nodoc


class _VideoMediaDetailState extends VideoMediaDetailState {
  const _VideoMediaDetailState({this.isLoading = true, this.hasError = false, this.areControlsVisible = false, this.isPlaying = false, this.isMuted = false}): super._();


@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool hasError;
@override@JsonKey() final  bool areControlsVisible;
@override@JsonKey() final  bool isPlaying;
@override@JsonKey() final  bool isMuted;

/// Create a copy of VideoMediaDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoMediaDetailStateCopyWith<_VideoMediaDetailState> get copyWith => __$VideoMediaDetailStateCopyWithImpl<_VideoMediaDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoMediaDetailState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.areControlsVisible, areControlsVisible) || other.areControlsVisible == areControlsVisible)&&(identical(other.isPlaying, isPlaying) || other.isPlaying == isPlaying)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,hasError,areControlsVisible,isPlaying,isMuted);

@override
String toString() {
  return 'VideoMediaDetailState(isLoading: $isLoading, hasError: $hasError, areControlsVisible: $areControlsVisible, isPlaying: $isPlaying, isMuted: $isMuted)';
}


}

/// @nodoc
abstract mixin class _$VideoMediaDetailStateCopyWith<$Res> implements $VideoMediaDetailStateCopyWith<$Res> {
  factory _$VideoMediaDetailStateCopyWith(_VideoMediaDetailState value, $Res Function(_VideoMediaDetailState) _then) = __$VideoMediaDetailStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, bool hasError, bool areControlsVisible, bool isPlaying, bool isMuted
});




}
/// @nodoc
class __$VideoMediaDetailStateCopyWithImpl<$Res>
    implements _$VideoMediaDetailStateCopyWith<$Res> {
  __$VideoMediaDetailStateCopyWithImpl(this._self, this._then);

  final _VideoMediaDetailState _self;
  final $Res Function(_VideoMediaDetailState) _then;

/// Create a copy of VideoMediaDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? hasError = null,Object? areControlsVisible = null,Object? isPlaying = null,Object? isMuted = null,}) {
  return _then(_VideoMediaDetailState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,areControlsVisible: null == areControlsVisible ? _self.areControlsVisible : areControlsVisible // ignore: cast_nullable_to_non_nullable
as bool,isPlaying: null == isPlaying ? _self.isPlaying : isPlaying // ignore: cast_nullable_to_non_nullable
as bool,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
