// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint

part of 'media_detail_state.dart';

mixin _$MediaDetailState {
  Media? get media;
  bool get isLoading;
  MediaFailure? get failure;
  bool get isHudVisible;
  bool get isHudClickMode;
  bool get isInfoVisible;
  bool get restoreHudAfterInfo;
  bool get restoreHudClickModeAfterInfo;
  $MediaDetailStateCopyWith<MediaDetailState> get copyWith;
}

abstract mixin class $MediaDetailStateCopyWith<$Res> {
  factory $MediaDetailStateCopyWith(MediaDetailState value, $Res Function(MediaDetailState) then) =
      _$MediaDetailStateCopyWithImpl;
  $Res call({
    Media? media,
    bool isLoading,
    MediaFailure? failure,
    bool isHudVisible,
    bool isHudClickMode,
    bool isInfoVisible,
    bool restoreHudAfterInfo,
    bool restoreHudClickModeAfterInfo,
  });
}

class _$MediaDetailStateCopyWithImpl<$Res> implements $MediaDetailStateCopyWith<$Res> {
  _$MediaDetailStateCopyWithImpl(this._self, this._then);
  final MediaDetailState _self;
  final $Res Function(MediaDetailState) _then;

  @override
  $Res call({
    Object? media = freezed,
    Object? isLoading = null,
    Object? failure = freezed,
    Object? isHudVisible = null,
    Object? isHudClickMode = null,
    Object? isInfoVisible = null,
    Object? restoreHudAfterInfo = null,
    Object? restoreHudClickModeAfterInfo = null,
  }) => _then(
    _self.copyWith(
      media: freezed == media ? _self.media : media as Media?,
      isLoading: null == isLoading ? _self.isLoading : isLoading as bool,
      failure: freezed == failure ? _self.failure : failure as MediaFailure?,
      isHudVisible: null == isHudVisible ? _self.isHudVisible : isHudVisible as bool,
      isHudClickMode: null == isHudClickMode ? _self.isHudClickMode : isHudClickMode as bool,
      isInfoVisible: null == isInfoVisible ? _self.isInfoVisible : isInfoVisible as bool,
      restoreHudAfterInfo: null == restoreHudAfterInfo ? _self.restoreHudAfterInfo : restoreHudAfterInfo as bool,
      restoreHudClickModeAfterInfo: null == restoreHudClickModeAfterInfo
          ? _self.restoreHudClickModeAfterInfo
          : restoreHudClickModeAfterInfo as bool,
    ),
  );
}

class _MediaDetailState extends MediaDetailState {
  const _MediaDetailState({
    this.media,
    this.isLoading = true,
    this.failure,
    this.isHudVisible = false,
    this.isHudClickMode = false,
    this.isInfoVisible = false,
    this.restoreHudAfterInfo = false,
    this.restoreHudClickModeAfterInfo = false,
  }) : super._();
  @override
  final Media? media;
  @override
  final bool isLoading;
  @override
  final MediaFailure? failure;
  @override
  final bool isHudVisible;
  @override
  final bool isHudClickMode;
  @override
  final bool isInfoVisible;
  @override
  final bool restoreHudAfterInfo;
  @override
  final bool restoreHudClickModeAfterInfo;
  @override
  _$MediaDetailStateCopyWith<_MediaDetailState> get copyWith =>
      __$MediaDetailStateCopyWithImpl<_MediaDetailState>(this, (value) => value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _MediaDetailState &&
          other.media == media &&
          other.isLoading == isLoading &&
          other.failure == failure &&
          other.isHudVisible == isHudVisible &&
          other.isHudClickMode == isHudClickMode &&
          other.isInfoVisible == isInfoVisible &&
          other.restoreHudAfterInfo == restoreHudAfterInfo &&
          other.restoreHudClickModeAfterInfo == restoreHudClickModeAfterInfo;
  @override
  int get hashCode => Object.hash(
    media,
    isLoading,
    failure,
    isHudVisible,
    isHudClickMode,
    isInfoVisible,
    restoreHudAfterInfo,
    restoreHudClickModeAfterInfo,
  );
}

abstract mixin class _$MediaDetailStateCopyWith<$Res> implements $MediaDetailStateCopyWith<$Res> {
  factory _$MediaDetailStateCopyWith(_MediaDetailState value, $Res Function(_MediaDetailState) then) =
      __$MediaDetailStateCopyWithImpl;
}

class __$MediaDetailStateCopyWithImpl<$Res> extends _$MediaDetailStateCopyWithImpl<$Res>
    implements _$MediaDetailStateCopyWith<$Res> {
  __$MediaDetailStateCopyWithImpl(this._self, $Res Function(_MediaDetailState) then)
    : super(_self, (value) => then(value as _MediaDetailState));
  final _MediaDetailState _self;

  @override
  $Res call({
    Object? media = freezed,
    Object? isLoading = null,
    Object? failure = freezed,
    Object? isHudVisible = null,
    Object? isHudClickMode = null,
    Object? isInfoVisible = null,
    Object? restoreHudAfterInfo = null,
    Object? restoreHudClickModeAfterInfo = null,
  }) => _then(
    _MediaDetailState(
      media: freezed == media ? _self.media : media as Media?,
      isLoading: null == isLoading ? _self.isLoading : isLoading as bool,
      failure: freezed == failure ? _self.failure : failure as MediaFailure?,
      isHudVisible: null == isHudVisible ? _self.isHudVisible : isHudVisible as bool,
      isHudClickMode: null == isHudClickMode ? _self.isHudClickMode : isHudClickMode as bool,
      isInfoVisible: null == isInfoVisible ? _self.isInfoVisible : isInfoVisible as bool,
      restoreHudAfterInfo: null == restoreHudAfterInfo ? _self.restoreHudAfterInfo : restoreHudAfterInfo as bool,
      restoreHudClickModeAfterInfo: null == restoreHudClickModeAfterInfo
          ? _self.restoreHudClickModeAfterInfo
          : restoreHudClickModeAfterInfo as bool,
    ),
  );
}
