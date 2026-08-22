import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/media/use_cases/load_media_detail_use_case.dart';
import 'package:nook/presentation/media/detail/cubit/media_detail_cubit.dart';
import 'package:nook/presentation/media/detail/media_detail_view.dart';

/// Route entry point for an individual media item.
@RoutePage()
class MediaDetailPage extends StatelessWidget {
  /// Default constructor.
  const MediaDetailPage({@PathParam('mediaId') required this.mediaId, this.initialMedia, super.key});

  /// Identifier from the media detail route path.
  final String mediaId;

  /// Media already available from the originating library view.
  final Media? initialMedia;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = MediaDetailCubit(loadMedia: context.read<LoadMediaDetailUseCase>());
        unawaited(cubit.loadMedia(mediaId, initialMedia: initialMedia));
        return cubit;
      },
      child: const MediaDetailView(),
    );
  }
}
