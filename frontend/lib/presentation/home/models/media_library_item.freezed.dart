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
  String get id;
  String get filename;
  String get mimeType;
  int get fileSize;
  DateTime get createdAt;
  MediaType get mediaType;
  Uint8List get bytes;
  PendingMediaStatus get status;

  /// Create a copy of PendingMediaLibraryItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PendingMediaLibraryItemCopyWith<PendingMediaLibraryItem> get copyWith =>
      _$PendingMediaLibraryItemCopyWithImpl<PendingMediaLibraryItem>(this as PendingMediaLibraryItem, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PendingMediaLibraryItem &&
            other.id == id &&
            other.filename == filename &&
            other.mimeType == mimeType &&
            other.fileSize == fileSize &&
            other.createdAt == createdAt &&
            other.mediaType == mediaType &&
            other.bytes == bytes &&
            other.status == status);
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, filename, mimeType, fileSize, createdAt, mediaType, bytes, status);

  @override
  String toString() {
    return 'PendingMediaLibraryItem(id: $id, filename: $filename, mimeType: $mimeType, fileSize: $fileSize, createdAt: $createdAt, mediaType: $mediaType, bytes: $bytes, status: $status)';
  }
}

/// @nodoc
abstract mixin class $PendingMediaLibraryItemCopyWith<$Res> {
  factory $PendingMediaLibraryItemCopyWith(
    PendingMediaLibraryItem value,
    $Res Function(PendingMediaLibraryItem) then,
  ) = _$PendingMediaLibraryItemCopyWithImpl;

  @useResult
  $Res call({
    String id,
    String filename,
    String mimeType,
    int fileSize,
    DateTime createdAt,
    MediaType mediaType,
    Uint8List bytes,
    PendingMediaStatus status,
  });
}

/// @nodoc
class _$PendingMediaLibraryItemCopyWithImpl<$Res> implements $PendingMediaLibraryItemCopyWith<$Res> {
  _$PendingMediaLibraryItemCopyWithImpl(this._self, this._then);

  final PendingMediaLibraryItem _self;
  final $Res Function(PendingMediaLibraryItem) _then;

  /// Create a copy of PendingMediaLibraryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? filename = null,
    Object? mimeType = null,
    Object? fileSize = null,
    Object? createdAt = null,
    Object? mediaType = null,
    Object? bytes = null,
    Object? status = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id ? _self.id : id as String,
        filename: null == filename ? _self.filename : filename as String,
        mimeType: null == mimeType ? _self.mimeType : mimeType as String,
        fileSize: null == fileSize ? _self.fileSize : fileSize as int,
        createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
        mediaType: null == mediaType ? _self.mediaType : mediaType as MediaType,
        bytes: null == bytes ? _self.bytes : bytes as Uint8List,
        status: null == status ? _self.status : status as PendingMediaStatus,
      ),
    );
  }
}

/// @nodoc
class _PendingMediaLibraryItem extends PendingMediaLibraryItem {
  const _PendingMediaLibraryItem({
    required this.id,
    required this.filename,
    required this.mimeType,
    required this.fileSize,
    required this.createdAt,
    required this.mediaType,
    required this.bytes,
    this.status = PendingMediaStatus.uploading,
  }) : super._();

  @override
  final String id;

  @override
  final String filename;

  @override
  final String mimeType;

  @override
  final int fileSize;

  @override
  final DateTime createdAt;

  @override
  final MediaType mediaType;

  @override
  final Uint8List bytes;

  @override
  final PendingMediaStatus status;

  /// Create a copy of PendingMediaLibraryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$PendingMediaLibraryItemCopyWith<_PendingMediaLibraryItem> get copyWith =>
      __$PendingMediaLibraryItemCopyWithImpl<_PendingMediaLibraryItem>(this, _$identity);
}

/// @nodoc
abstract mixin class _$PendingMediaLibraryItemCopyWith<$Res>
    implements $PendingMediaLibraryItemCopyWith<$Res> {
  factory _$PendingMediaLibraryItemCopyWith(
    _PendingMediaLibraryItem value,
    $Res Function(_PendingMediaLibraryItem) then,
  ) = __$PendingMediaLibraryItemCopyWithImpl;

  @override
  @useResult
  $Res call({
    String id,
    String filename,
    String mimeType,
    int fileSize,
    DateTime createdAt,
    MediaType mediaType,
    Uint8List bytes,
    PendingMediaStatus status,
  });
}

/// @nodoc
class __$PendingMediaLibraryItemCopyWithImpl<$Res>
    extends _$PendingMediaLibraryItemCopyWithImpl<$Res>
    implements _$PendingMediaLibraryItemCopyWith<$Res> {
  __$PendingMediaLibraryItemCopyWithImpl(this._self, this._privateThen)
    : super(_self, (PendingMediaLibraryItem value) => _privateThen(value as _PendingMediaLibraryItem));

  final _PendingMediaLibraryItem _self;
  final $Res Function(_PendingMediaLibraryItem) _privateThen;

  /// Create a copy of PendingMediaLibraryItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? filename = null,
    Object? mimeType = null,
    Object? fileSize = null,
    Object? createdAt = null,
    Object? mediaType = null,
    Object? bytes = null,
    Object? status = null,
  }) {
    return _privateThen(
      _PendingMediaLibraryItem(
        id: null == id ? _self.id : id as String,
        filename: null == filename ? _self.filename : filename as String,
        mimeType: null == mimeType ? _self.mimeType : mimeType as String,
        fileSize: null == fileSize ? _self.fileSize : fileSize as int,
        createdAt: null == createdAt ? _self.createdAt : createdAt as DateTime,
        mediaType: null == mediaType ? _self.mediaType : mediaType as MediaType,
        bytes: null == bytes ? _self.bytes : bytes as Uint8List,
        status: null == status ? _self.status : status as PendingMediaStatus,
      ),
    );
  }
}

// dart format on
