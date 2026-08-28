// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_library_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PendingMediaLibraryItem {

 String get id; String get filename; String get mimeType; int get fileSize; DateTime get createdAt; MediaType get mediaType; Uint8List get bytes; PendingMediaStatus get status;
/// Create a copy of PendingMediaLibraryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingMediaLibraryItemCopyWith<PendingMediaLibraryItem> get copyWith => _$PendingMediaLibraryItemCopyWithImpl<PendingMediaLibraryItem>(this as PendingMediaLibraryItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingMediaLibraryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,filename,mimeType,fileSize,createdAt,mediaType,const DeepCollectionEquality().hash(bytes),status);

@override
String toString() {
  return 'PendingMediaLibraryItem(id: $id, filename: $filename, mimeType: $mimeType, fileSize: $fileSize, createdAt: $createdAt, mediaType: $mediaType, bytes: $bytes, status: $status)';
}


}

/// @nodoc
abstract mixin class $PendingMediaLibraryItemCopyWith<$Res>  {
  factory $PendingMediaLibraryItemCopyWith(PendingMediaLibraryItem value, $Res Function(PendingMediaLibraryItem) _then) = _$PendingMediaLibraryItemCopyWithImpl;
@useResult
$Res call({
 String id, String filename, String mimeType, int fileSize, DateTime createdAt, MediaType mediaType, Uint8List bytes, PendingMediaStatus status
});




}
/// @nodoc
class _$PendingMediaLibraryItemCopyWithImpl<$Res>
    implements $PendingMediaLibraryItemCopyWith<$Res> {
  _$PendingMediaLibraryItemCopyWithImpl(this._self, this._then);

  final PendingMediaLibraryItem _self;
  final $Res Function(PendingMediaLibraryItem) _then;

/// Create a copy of PendingMediaLibraryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? filename = null,Object? mimeType = null,Object? fileSize = null,Object? createdAt = null,Object? mediaType = null,Object? bytes = null,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PendingMediaStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingMediaLibraryItem].
extension PendingMediaLibraryItemPatterns on PendingMediaLibraryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingMediaLibraryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingMediaLibraryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingMediaLibraryItem value)  $default,){
final _that = this;
switch (_that) {
case _PendingMediaLibraryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingMediaLibraryItem value)?  $default,){
final _that = this;
switch (_that) {
case _PendingMediaLibraryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String filename,  String mimeType,  int fileSize,  DateTime createdAt,  MediaType mediaType,  Uint8List bytes,  PendingMediaStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingMediaLibraryItem() when $default != null:
return $default(_that.id,_that.filename,_that.mimeType,_that.fileSize,_that.createdAt,_that.mediaType,_that.bytes,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String filename,  String mimeType,  int fileSize,  DateTime createdAt,  MediaType mediaType,  Uint8List bytes,  PendingMediaStatus status)  $default,) {final _that = this;
switch (_that) {
case _PendingMediaLibraryItem():
return $default(_that.id,_that.filename,_that.mimeType,_that.fileSize,_that.createdAt,_that.mediaType,_that.bytes,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String filename,  String mimeType,  int fileSize,  DateTime createdAt,  MediaType mediaType,  Uint8List bytes,  PendingMediaStatus status)?  $default,) {final _that = this;
switch (_that) {
case _PendingMediaLibraryItem() when $default != null:
return $default(_that.id,_that.filename,_that.mimeType,_that.fileSize,_that.createdAt,_that.mediaType,_that.bytes,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _PendingMediaLibraryItem extends PendingMediaLibraryItem {
  const _PendingMediaLibraryItem({required this.id, required this.filename, required this.mimeType, required this.fileSize, required this.createdAt, required this.mediaType, required this.bytes, this.status = PendingMediaStatus.uploading}): super._();


@override final  String id;
@override final  String filename;
@override final  String mimeType;
@override final  int fileSize;
@override final  DateTime createdAt;
@override final  MediaType mediaType;
@override final  Uint8List bytes;
@override@JsonKey() final  PendingMediaStatus status;

/// Create a copy of PendingMediaLibraryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingMediaLibraryItemCopyWith<_PendingMediaLibraryItem> get copyWith => __$PendingMediaLibraryItemCopyWithImpl<_PendingMediaLibraryItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingMediaLibraryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.filename, filename) || other.filename == filename)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.fileSize, fileSize) || other.fileSize == fileSize)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&const DeepCollectionEquality().equals(other.bytes, bytes)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,id,filename,mimeType,fileSize,createdAt,mediaType,const DeepCollectionEquality().hash(bytes),status);

@override
String toString() {
  return 'PendingMediaLibraryItem(id: $id, filename: $filename, mimeType: $mimeType, fileSize: $fileSize, createdAt: $createdAt, mediaType: $mediaType, bytes: $bytes, status: $status)';
}


}

/// @nodoc
abstract mixin class _$PendingMediaLibraryItemCopyWith<$Res> implements $PendingMediaLibraryItemCopyWith<$Res> {
  factory _$PendingMediaLibraryItemCopyWith(_PendingMediaLibraryItem value, $Res Function(_PendingMediaLibraryItem) _then) = __$PendingMediaLibraryItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String filename, String mimeType, int fileSize, DateTime createdAt, MediaType mediaType, Uint8List bytes, PendingMediaStatus status
});




}
/// @nodoc
class __$PendingMediaLibraryItemCopyWithImpl<$Res>
    implements _$PendingMediaLibraryItemCopyWith<$Res> {
  __$PendingMediaLibraryItemCopyWithImpl(this._self, this._then);

  final _PendingMediaLibraryItem _self;
  final $Res Function(_PendingMediaLibraryItem) _then;

/// Create a copy of PendingMediaLibraryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? filename = null,Object? mimeType = null,Object? fileSize = null,Object? createdAt = null,Object? mediaType = null,Object? bytes = null,Object? status = null,}) {
  return _then(_PendingMediaLibraryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,filename: null == filename ? _self.filename : filename // ignore: cast_nullable_to_non_nullable
as String,mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,fileSize: null == fileSize ? _self.fileSize : fileSize // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as MediaType,bytes: null == bytes ? _self.bytes : bytes // ignore: cast_nullable_to_non_nullable
as Uint8List,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PendingMediaStatus,
  ));
}


}

// dart format on
