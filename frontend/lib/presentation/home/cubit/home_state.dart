import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/presentation/home/models/media_library_item.dart';

part 'home_state.freezed.dart';

/// The current state of the media library.
@freezed
sealed class HomeState with _$HomeState {
  const HomeState._();

  /// The media library is loading without available data.
  const factory HomeState.loading() = HomeLoading;

  /// The media library is available.
  const factory HomeState.loaded({@Default(<MediaLibraryItem>[]) List<MediaLibraryItem> items}) = HomeLoaded;

  /// The media library failed to load without available data.
  const factory HomeState.error({required MediaFailure failure}) = HomeError;
}
