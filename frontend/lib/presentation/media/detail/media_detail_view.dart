import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/media/detail/cubit/media_detail_cubit.dart';
import 'package:nook/presentation/media/detail/cubit/media_detail_presentation_event.dart';
import 'package:nook/presentation/media/detail/cubit/media_detail_state.dart';
import 'package:nook/presentation/media/detail/image_media_detail_view.dart';
import 'package:nook/presentation/media/detail/video_media_detail_view.dart';
import 'package:nook/presentation/media/detail/widgets/media_fallback.dart';
import 'package:nook/presentation/media/detail/widgets/media_info.dart';
import 'package:nook/presentation/utils/app_notification.dart';
import 'package:nook/presentation/utils/build_context_layout.dart';

/// Displays loaded media detail and route-level controls.
class MediaDetailView extends StatefulWidget {
  /// Default constructor.
  const MediaDetailView({super.key});

  @override
  State<MediaDetailView> createState() => _MediaDetailViewState();
}

class _MediaDetailViewState extends State<MediaDetailView> {
  bool get _usesNativeFullscreen => !kIsWeb;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => unawaited(_syncSystemUi()));
  }

  @override
  void dispose() {
    unawaited(_restoreSystemUi());
    super.dispose();
  }

  Future<void> _syncSystemUi() async {
    if (!_usesNativeFullscreen || !mounted) return;
    final state = context.read<MediaDetailCubit>().state;
    if (state.isHudVisible || state.isInfoVisible) {
      await _restoreSystemUi();
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }
  }

  Future<void> _restoreSystemUi() => SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  Future<void> _navigateBack() async {
    await _restoreSystemUi();
    if (!mounted) return;
    final didPop = await context.router.maybePop();
    if (!didPop && mounted) await context.router.replacePath('/home');
  }

  Future<void> _openMobileInfo(Media media) async {
    context.read<MediaDetailCubit>().openInfo();
    await _syncSystemUi();
    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.86),
          child: MediaInfo(media: media),
        ),
      ),
    );
    if (mounted) context.read<MediaDetailCubit>().closeInfo();
  }

  void _showFailure(MediaFailure failure) {
    showAppNotification(context, switch (failure) {
      InvalidMediaFailure() => context.l10n.mediaFailureNotFound,
      UnauthenticatedMediaFailure() => context.l10n.mediaFailureUnauthenticated,
      UnknownMediaFailure() => context.l10n.mediaFailureUnknown,
    }, type: AppNotificationType.error);
  }

  @override
  Widget build(BuildContext context) {
    return BlocPresentationListener<MediaDetailCubit, MediaDetailPresentationEvent>(
      listener: (context, event) {
        switch (event) {
          case MediaDetailLoadFailed(:final failure):
            _showFailure(failure);
        }
      },
      child: BlocListener<MediaDetailCubit, MediaDetailState>(
        listenWhen: (previous, current) =>
            previous.isHudVisible != current.isHudVisible || previous.isInfoVisible != current.isInfoVisible,
        listener: (_, _) => unawaited(_syncSystemUi()),
        child: PopScope(
          onPopInvokedWithResult: (_, _) => unawaited(_restoreSystemUi()),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: BlocBuilder<MediaDetailCubit, MediaDetailState>(
              builder: (context, state) => _MediaDetailContent(
                state: state,
                onBack: () => unawaited(_navigateBack()),
                onMobileInfo: _openMobileInfo,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaDetailContent extends StatelessWidget {
  const _MediaDetailContent({required this.state, required this.onBack, required this.onMobileInfo});

  final MediaDetailState state;
  final VoidCallback onBack;
  final Future<void> Function(Media media) onMobileInfo;

  @override
  Widget build(BuildContext context) {
    final media = state.media;
    if (state.isLoading && media == null) {
      return const Center(child: CircularProgressIndicator());
    }
    if (media == null) {
      return Center(child: Text(context.l10n.mediaFailureLoad));
    }
    final cubit = context.read<MediaDetailCubit>();
    final isWeb = context.layoutMode == AppLayoutMode.web;
    return MouseRegion(
      onEnter: (_) => cubit.showHoverHud(media),
      onHover: (_) => cubit.showHoverHud(media),
      onExit: (_) => cubit.hideHoverHud(media),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: Colors.black,
            child: Center(
              child: switch (media.mediaType) {
                MediaType.image => ImageMediaDetailView(media: media, onToggleHud: () => cubit.toggleHud(media)),
                MediaType.video => switch (media) {
                  final MediaDetail detail => VideoMediaDetailView(media: detail),
                  Media(:final previewUrl) =>
                    previewUrl == null
                        ? MediaFallback(media: media)
                        : GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () => cubit.toggleHud(media),
                            child: CachedNetworkImage(
                              imageUrl: previewUrl,
                              fit: BoxFit.contain,
                              errorWidget: (_, _, _) => MediaFallback(media: media),
                            ),
                          ),
                },
              },
            ),
          ),
          if (isWeb) _WebInfoPanel(media: media, isVisible: state.isInfoVisible, onClose: cubit.closeInfo),
          if (!(isWeb && state.isInfoVisible))
            _MediaHud(
              media: media,
              isVisible: state.isHudVisible,
              onBack: onBack,
              onInfo: () {
                if (isWeb) {
                  cubit.openInfo();
                } else {
                  unawaited(onMobileInfo(media));
                }
              },
            ),
        ],
      ),
    );
  }
}

class _MediaHud extends StatelessWidget {
  const _MediaHud({required this.media, required this.isVisible, required this.onBack, required this.onInfo});

  final Media media;
  final bool isVisible;
  final VoidCallback onBack;
  final VoidCallback onInfo;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1 : 0,
      duration: const Duration(milliseconds: 180),
      child: IgnorePointer(
        ignoring: !isVisible,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 144,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xB3000000), Color(0x00000000)],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: onBack,
                      icon: const Icon(Icons.arrow_back_rounded),
                      color: Colors.white,
                      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          media.displayName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: onInfo,
                      icon: const Icon(Icons.info_outline_rounded),
                      color: Colors.white,
                      tooltip: context.l10n.mediaDetailsTitle,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WebInfoPanel extends StatelessWidget {
  const _WebInfoPanel({required this.media, required this.isVisible, required this.onClose});

  final Media media;
  final bool isVisible;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isVisible,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onClose),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 420),
              curve: Curves.easeInOutCubic,
              offset: isVisible ? Offset.zero : const Offset(1, 0),
              child: SizedBox(
                width: 420,
                child: _InfoPanel(media: media, onClose: onClose),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({required this.media, required this.onClose});

  final Media media;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.96),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(context.l10n.mediaDetailsTitle, style: Theme.of(context).textTheme.titleLarge),
                  ),
                ),
                IconButton(
                  onPressed: onClose,
                  icon: const Icon(Icons.close_rounded),
                  tooltip: context.l10n.mediaDetailsCloseTooltip,
                ),
              ],
            ),
            Expanded(child: MediaInfo(media: media)),
          ],
        ),
      ),
    );
  }
}
