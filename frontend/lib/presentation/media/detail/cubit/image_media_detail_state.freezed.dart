// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint

part of 'image_media_detail_state.dart';

mixin _$ImageMediaDetailState {
  String? get imageUrl;
  bool get isLoading;
  $ImageMediaDetailStateCopyWith<ImageMediaDetailState> get copyWith;
}

abstract mixin class $ImageMediaDetailStateCopyWith<$Res> {
  factory $ImageMediaDetailStateCopyWith(ImageMediaDetailState value, $Res Function(ImageMediaDetailState) then) =
      _$ImageMediaDetailStateCopyWithImpl;
  $Res call({String? imageUrl, bool isLoading});
}

class _$ImageMediaDetailStateCopyWithImpl<$Res> implements $ImageMediaDetailStateCopyWith<$Res> {
  _$ImageMediaDetailStateCopyWithImpl(this._self, this._then);
  final ImageMediaDetailState _self;
  final $Res Function(ImageMediaDetailState) _then;
  @override
  $Res call({Object? imageUrl = freezed, Object? isLoading = null}) => _then(
    _self.copyWith(
      imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl as String?,
      isLoading: null == isLoading ? _self.isLoading : isLoading as bool,
    ),
  );
}

class _ImageMediaDetailState extends ImageMediaDetailState {
  const _ImageMediaDetailState({this.imageUrl, this.isLoading = true}) : super._();
  @override
  final String? imageUrl;
  @override
  final bool isLoading;
  @override
  _$ImageMediaDetailStateCopyWith<_ImageMediaDetailState> get copyWith =>
      __$ImageMediaDetailStateCopyWithImpl<_ImageMediaDetailState>(this, (value) => value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ImageMediaDetailState && other.imageUrl == imageUrl && other.isLoading == isLoading;
  @override
  int get hashCode => Object.hash(imageUrl, isLoading);
}

abstract mixin class _$ImageMediaDetailStateCopyWith<$Res> implements $ImageMediaDetailStateCopyWith<$Res> {
  factory _$ImageMediaDetailStateCopyWith(_ImageMediaDetailState value, $Res Function(_ImageMediaDetailState) then) =
      __$ImageMediaDetailStateCopyWithImpl;
}

class __$ImageMediaDetailStateCopyWithImpl<$Res> extends _$ImageMediaDetailStateCopyWithImpl<$Res>
    implements _$ImageMediaDetailStateCopyWith<$Res> {
  __$ImageMediaDetailStateCopyWithImpl(this._self, $Res Function(_ImageMediaDetailState) then)
    : super(_self, (value) => then(value as _ImageMediaDetailState));
  final _ImageMediaDetailState _self;

  @override
  $Res call({Object? imageUrl = freezed, Object? isLoading = null}) => _then(
    _ImageMediaDetailState(
      imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl as String?,
      isLoading: null == isLoading ? _self.isLoading : isLoading as bool,
    ),
  );
}
