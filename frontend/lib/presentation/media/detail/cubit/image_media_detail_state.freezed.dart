// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'image_media_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImageMediaDetailState {

 String? get imageUrl; bool get isLoading;
/// Create a copy of ImageMediaDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImageMediaDetailStateCopyWith<ImageMediaDetailState> get copyWith => _$ImageMediaDetailStateCopyWithImpl<ImageMediaDetailState>(this as ImageMediaDetailState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImageMediaDetailState&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,imageUrl,isLoading);

@override
String toString() {
  return 'ImageMediaDetailState(imageUrl: $imageUrl, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $ImageMediaDetailStateCopyWith<$Res>  {
  factory $ImageMediaDetailStateCopyWith(ImageMediaDetailState value, $Res Function(ImageMediaDetailState) _then) = _$ImageMediaDetailStateCopyWithImpl;
@useResult
$Res call({
 String? imageUrl, bool isLoading
});




}
/// @nodoc
class _$ImageMediaDetailStateCopyWithImpl<$Res>
    implements $ImageMediaDetailStateCopyWith<$Res> {
  _$ImageMediaDetailStateCopyWithImpl(this._self, this._then);

  final ImageMediaDetailState _self;
  final $Res Function(ImageMediaDetailState) _then;

/// Create a copy of ImageMediaDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? imageUrl = freezed,Object? isLoading = null,}) {
  return _then(_self.copyWith(
imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ImageMediaDetailState].
extension ImageMediaDetailStatePatterns on ImageMediaDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImageMediaDetailState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImageMediaDetailState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImageMediaDetailState value)  $default,){
final _that = this;
switch (_that) {
case _ImageMediaDetailState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImageMediaDetailState value)?  $default,){
final _that = this;
switch (_that) {
case _ImageMediaDetailState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? imageUrl,  bool isLoading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImageMediaDetailState() when $default != null:
return $default(_that.imageUrl,_that.isLoading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? imageUrl,  bool isLoading)  $default,) {final _that = this;
switch (_that) {
case _ImageMediaDetailState():
return $default(_that.imageUrl,_that.isLoading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? imageUrl,  bool isLoading)?  $default,) {final _that = this;
switch (_that) {
case _ImageMediaDetailState() when $default != null:
return $default(_that.imageUrl,_that.isLoading);case _:
  return null;

}
}

}

/// @nodoc


class _ImageMediaDetailState extends ImageMediaDetailState {
  const _ImageMediaDetailState({this.imageUrl, this.isLoading = true}): super._();


@override final  String? imageUrl;
@override@JsonKey() final  bool isLoading;

/// Create a copy of ImageMediaDetailState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImageMediaDetailStateCopyWith<_ImageMediaDetailState> get copyWith => __$ImageMediaDetailStateCopyWithImpl<_ImageMediaDetailState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImageMediaDetailState&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,imageUrl,isLoading);

@override
String toString() {
  return 'ImageMediaDetailState(imageUrl: $imageUrl, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class _$ImageMediaDetailStateCopyWith<$Res> implements $ImageMediaDetailStateCopyWith<$Res> {
  factory _$ImageMediaDetailStateCopyWith(_ImageMediaDetailState value, $Res Function(_ImageMediaDetailState) _then) = __$ImageMediaDetailStateCopyWithImpl;
@override @useResult
$Res call({
 String? imageUrl, bool isLoading
});




}
/// @nodoc
class __$ImageMediaDetailStateCopyWithImpl<$Res>
    implements _$ImageMediaDetailStateCopyWith<$Res> {
  __$ImageMediaDetailStateCopyWithImpl(this._self, this._then);

  final _ImageMediaDetailState _self;
  final $Res Function(_ImageMediaDetailState) _then;

/// Create a copy of ImageMediaDetailState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? imageUrl = freezed,Object? isLoading = null,}) {
  return _then(_ImageMediaDetailState(
imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
