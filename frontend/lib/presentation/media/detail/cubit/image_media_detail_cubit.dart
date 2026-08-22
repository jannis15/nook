import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/presentation/media/detail/cubit/image_media_detail_state.dart';

/// Manages observable loading state for an image detail view.
class ImageMediaDetailCubit extends Cubit<ImageMediaDetailState> {
  /// Default constructor.
  ImageMediaDetailCubit() : super(const ImageMediaDetailState());

  /// Reports the resolved image [url].
  void imageLoaded(String url) {
    emit(ImageMediaDetailState(imageUrl: url, isLoading: false));
  }
}
