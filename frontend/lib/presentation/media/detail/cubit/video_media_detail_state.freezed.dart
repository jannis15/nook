// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint

part of 'video_media_detail_state.dart';

mixin _$VideoMediaDetailState {
  bool get isLoading;
  bool get hasError;
  bool get areControlsVisible;
  bool get isPlaying;
  bool get isMuted;
  $VideoMediaDetailStateCopyWith<VideoMediaDetailState> get copyWith;
}

abstract mixin class $VideoMediaDetailStateCopyWith<$Res> {
  factory $VideoMediaDetailStateCopyWith(VideoMediaDetailState value, $Res Function(VideoMediaDetailState) then) =
      _$VideoMediaDetailStateCopyWithImpl;
  $Res call({bool isLoading, bool hasError, bool areControlsVisible, bool isPlaying, bool isMuted});
}

class _$VideoMediaDetailStateCopyWithImpl<$Res> implements $VideoMediaDetailStateCopyWith<$Res> {
  _$VideoMediaDetailStateCopyWithImpl(this._self, this._then);
  final VideoMediaDetailState _self;
  final $Res Function(VideoMediaDetailState) _then;
  @override
  $Res call({
    Object? isLoading = null,
    Object? hasError = null,
    Object? areControlsVisible = null,
    Object? isPlaying = null,
    Object? isMuted = null,
  }) => _then(
    _self.copyWith(
      isLoading: null == isLoading ? _self.isLoading : isLoading as bool,
      hasError: null == hasError ? _self.hasError : hasError as bool,
      areControlsVisible: null == areControlsVisible ? _self.areControlsVisible : areControlsVisible as bool,
      isPlaying: null == isPlaying ? _self.isPlaying : isPlaying as bool,
      isMuted: null == isMuted ? _self.isMuted : isMuted as bool,
    ),
  );
}

class _VideoMediaDetailState extends VideoMediaDetailState {
  const _VideoMediaDetailState({
    this.isLoading = true,
    this.hasError = false,
    this.areControlsVisible = false,
    this.isPlaying = false,
    this.isMuted = false,
  }) : super._();
  @override
  final bool isLoading;
  @override
  final bool hasError;
  @override
  final bool areControlsVisible;
  @override
  final bool isPlaying;
  @override
  final bool isMuted;
  @override
  _$VideoMediaDetailStateCopyWith<_VideoMediaDetailState> get copyWith =>
      __$VideoMediaDetailStateCopyWithImpl<_VideoMediaDetailState>(this, (value) => value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _VideoMediaDetailState &&
          other.isLoading == isLoading &&
          other.hasError == hasError &&
          other.areControlsVisible == areControlsVisible &&
          other.isPlaying == isPlaying &&
          other.isMuted == isMuted;
  @override
  int get hashCode => Object.hash(isLoading, hasError, areControlsVisible, isPlaying, isMuted);
}

abstract mixin class _$VideoMediaDetailStateCopyWith<$Res> implements $VideoMediaDetailStateCopyWith<$Res> {
  factory _$VideoMediaDetailStateCopyWith(_VideoMediaDetailState value, $Res Function(_VideoMediaDetailState) then) =
      __$VideoMediaDetailStateCopyWithImpl;
}

class __$VideoMediaDetailStateCopyWithImpl<$Res> extends _$VideoMediaDetailStateCopyWithImpl<$Res>
    implements _$VideoMediaDetailStateCopyWith<$Res> {
  __$VideoMediaDetailStateCopyWithImpl(this._self, $Res Function(_VideoMediaDetailState) then)
    : super(_self, (value) => then(value as _VideoMediaDetailState));
  final _VideoMediaDetailState _self;

  @override
  $Res call({
    Object? isLoading = null,
    Object? hasError = null,
    Object? areControlsVisible = null,
    Object? isPlaying = null,
    Object? isMuted = null,
  }) => _then(
    _VideoMediaDetailState(
      isLoading: null == isLoading ? _self.isLoading : isLoading as bool,
      hasError: null == hasError ? _self.hasError : hasError as bool,
      areControlsVisible: null == areControlsVisible ? _self.areControlsVisible : areControlsVisible as bool,
      isPlaying: null == isPlaying ? _self.isPlaying : isPlaying as bool,
      isMuted: null == isMuted ? _self.isMuted : isMuted as bool,
    ),
  );
}
