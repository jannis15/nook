import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/media/detail/cubit/video_media_detail_cubit.dart';
import 'package:nook/presentation/media/detail/cubit/video_media_detail_state.dart';
import 'package:nook/presentation/media/detail/widgets/media_fallback.dart';
import 'package:video_player/video_player.dart';

/// Displays video content with widget-local platform player resources.
class VideoMediaDetailView extends StatelessWidget {
  /// Default constructor.
  const VideoMediaDetailView({required this.media, super.key});

  /// Detailed media to display.
  final MediaDetail media;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VideoMediaDetailCubit(),
      child: _VideoStage(media: media),
    );
  }
}

class _VideoStage extends StatefulWidget {
  const _VideoStage({required this.media});

  final MediaDetail media;

  @override
  State<_VideoStage> createState() => _VideoStageState();
}

class _VideoStageState extends State<_VideoStage> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    unawaited(_initialiseController());
  }

  @override
  void didUpdateWidget(covariant _VideoStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.media.mediaUrl != widget.media.mediaUrl) unawaited(_initialiseController());
  }

  @override
  void dispose() {
    _controller?.removeListener(_onControllerChanged);
    unawaited(_controller?.dispose());
    super.dispose();
  }

  Future<void> _initialiseController() async {
    final mediaUrl = widget.media.mediaUrl;
    if (mediaUrl.isEmpty) {
      context.read<VideoMediaDetailCubit>().setError();
      return;
    }
    final oldController = _controller;
    oldController?.removeListener(_onControllerChanged);
    _controller = null;
    context.read<VideoMediaDetailCubit>().setLoading(true);
    await oldController?.dispose();
    final controller = VideoPlayerController.networkUrl(Uri.parse(mediaUrl));
    controller.addListener(_onControllerChanged);
    try {
      await controller.initialize();
      await controller.setLooping(true);
    } catch (_) {
      controller.removeListener(_onControllerChanged);
      await controller.dispose();
      if (mounted) context.read<VideoMediaDetailCubit>().setError();
      return;
    }
    if (!mounted) {
      controller.removeListener(_onControllerChanged);
      await controller.dispose();
      return;
    }
    _controller = controller;
    _onControllerChanged();
  }

  void _onControllerChanged() {
    final controller = _controller;
    if (!mounted || controller == null) return;
    final value = controller.value;
    if (value.hasError) {
      context.read<VideoMediaDetailCubit>().setError();
    } else {
      context.read<VideoMediaDetailCubit>().synchronisePlayback(isPlaying: value.isPlaying, isMuted: value.volume == 0);
    }
  }

  Future<void> _togglePlayback() async {
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      await controller.play();
    }
  }

  Future<void> _toggleMute() async {
    final controller = _controller;
    if (controller == null) return;
    await controller.setVolume(controller.value.volume > 0 ? 0 : 1);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoMediaDetailCubit, VideoMediaDetailState>(
      builder: (context, state) {
        final controller = _controller;
        if (state.hasError) return MediaFallback(media: widget.media);
        if (state.isLoading || controller == null || !controller.value.isInitialized) {
          return Stack(
            fit: StackFit.expand,
            children: [
              MediaFallback(media: widget.media),
              const Center(child: CircularProgressIndicator()),
            ],
          );
        }
        return MouseRegion(
          onEnter: (_) => kIsWeb ? context.read<VideoMediaDetailCubit>().setControlsVisible(true) : null,
          onHover: (_) => kIsWeb ? context.read<VideoMediaDetailCubit>().setControlsVisible(true) : null,
          onExit: (_) => kIsWeb ? context.read<VideoMediaDetailCubit>().setControlsVisible(false) : null,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: AspectRatio(aspectRatio: controller.value.aspectRatio, child: VideoPlayer(controller)),
              ),
              Positioned.fill(
                child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => unawaited(_togglePlayback())),
              ),
              Center(
                child: _PlaybackButton(state: state, onPressed: _togglePlayback),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16 + MediaQuery.paddingOf(context).bottom,
                child: _VideoControls(state: state, onPlayback: _togglePlayback, onMute: _toggleMute),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlaybackButton extends StatelessWidget {
  const _PlaybackButton({required this.state, required this.onPressed});

  final VideoMediaDetailState state;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: state.areControlsVisible && !state.isPlaying ? 1 : 0,
      duration: const Duration(milliseconds: 160),
      child: IgnorePointer(
        ignoring: state.isPlaying || !state.areControlsVisible,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.52),
            borderRadius: BorderRadius.circular(999),
          ),
          child: IconButton(
            onPressed: () => unawaited(onPressed()),
            iconSize: 52,
            color: Colors.white,
            icon: Icon(state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
            tooltip: state.isPlaying ? context.l10n.mediaPauseVideoTooltip : context.l10n.mediaPlayVideoTooltip,
          ),
        ),
      ),
    );
  }
}

class _VideoControls extends StatelessWidget {
  const _VideoControls({required this.state, required this.onPlayback, required this.onMute});

  final VideoMediaDetailState state;
  final Future<void> Function() onPlayback;
  final Future<void> Function() onMute;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: state.areControlsVisible ? 1 : 0,
      duration: const Duration(milliseconds: 160),
      child: IgnorePointer(
        ignoring: !state.areControlsVisible,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.48),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => unawaited(onPlayback()),
                icon: Icon(state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                color: Colors.white,
                tooltip: state.isPlaying ? context.l10n.mediaPauseVideoTooltip : context.l10n.mediaPlayVideoTooltip,
              ),
              const Spacer(),
              IconButton(
                onPressed: () => unawaited(onMute()),
                icon: Icon(state.isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded),
                color: Colors.white,
                tooltip: state.isMuted ? context.l10n.mediaUnmuteVideoTooltip : context.l10n.mediaMuteVideoTooltip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
