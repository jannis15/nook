import 'package:flutter_test/flutter_test.dart';
import 'package:nook/presentation/media/detail/cubit/image_media_detail_state.dart';
import 'package:nook/presentation/media/detail/cubit/media_detail_state.dart';
import 'package:nook/presentation/media/detail/cubit/video_media_detail_state.dart';

void main() {
  group('media detail states', () {
    test('copyWith creates updated states without recursion', () {
      final MediaDetailState mediaState = const MediaDetailState().copyWith(isLoading: false, isHudVisible: true);
      final ImageMediaDetailState imageState = const ImageMediaDetailState().copyWith(isLoading: false);
      final VideoMediaDetailState videoState = const VideoMediaDetailState().copyWith(isPlaying: true);

      expect(mediaState.isLoading, isFalse);
      expect(mediaState.isHudVisible, isTrue);
      expect(imageState.isLoading, isFalse);
      expect(videoState.isPlaying, isTrue);
    });
  });
}
