import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/presentation/media/detail/cubit/image_media_detail_cubit.dart';
import 'package:nook/presentation/media/detail/cubit/image_media_detail_state.dart';
import 'package:nook/presentation/media/detail/widgets/media_fallback.dart';

/// Displays a zoomable image and synchronises its loading state.
class ImageMediaDetailView extends StatelessWidget {
  /// Default constructor.
  const ImageMediaDetailView({required this.media, required this.onToggleHud, super.key});

  /// Media to display.
  final Media media;

  /// Invoked after a single-pointer tap.
  final VoidCallback onToggleHud;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ImageMediaDetailCubit(),
      child: _ImageStage(media: media, onToggleHud: onToggleHud),
    );
  }
}

class _ImageStage extends StatefulWidget {
  const _ImageStage({required this.media, required this.onToggleHud});

  final Media media;
  final VoidCallback onToggleHud;

  @override
  State<_ImageStage> createState() => _ImageStageState();
}

class _ImageStageState extends State<_ImageStage> with SingleTickerProviderStateMixin {
  final Map<ImageStream, ImageStreamListener> _listeners = <ImageStream, ImageStreamListener>{};
  late final TransformationController _transformationController;
  AnimationController? _resetController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _loadImages();
  }

  @override
  void didUpdateWidget(covariant _ImageStage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_mediaUrl(oldWidget.media) != _mediaUrl(widget.media)) {
      _clearListeners();
      _loadImages();
    }
  }

  @override
  void dispose() {
    _resetController?.dispose();
    _transformationController.dispose();
    _clearListeners();
    super.dispose();
  }

  void _loadImages() {
    final mediaUrl = _mediaUrl(widget.media);
    if (mediaUrl == null || mediaUrl.isEmpty) return;
    final stream = CachedNetworkImageProvider(mediaUrl).resolve(ImageConfiguration.empty);
    final listener = ImageStreamListener((_, _) {
      if (mounted) context.read<ImageMediaDetailCubit>().imageLoaded(mediaUrl);
    });
    stream.addListener(listener);
    _listeners[stream] = listener;
  }

  void _clearListeners() {
    for (final MapEntry<ImageStream, ImageStreamListener> entry in _listeners.entries) {
      entry.key.removeListener(entry.value);
    }
    _listeners.clear();
  }

  String? _mediaUrl(Media media) {
    return switch (media) {
      MediaDetail(:final mediaUrl) => mediaUrl,
      Media() => null,
    };
  }

  void _handleInteractionEnd(ScaleEndDetails details) {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if (!scale.isFinite || scale <= 1.001) {
      _transformationController.value = Matrix4.identity();
    } else if (scale <= 1.04) {
      _resetTransform();
    }
  }

  void _resetTransform() {
    _resetController?.dispose();
    final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 180));
    _resetController = controller;
    final animation = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
    controller
      ..addListener(() => _transformationController.value = animation.value)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _transformationController.value = Matrix4.identity();
        }
      })
      ..forward().ignore();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImageMediaDetailCubit, ImageMediaDetailState>(
      builder: (context, state) => _TapListener(
        onTap: widget.onToggleHud,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 1,
          maxScale: 5,
          onInteractionStart: (_) => _resetController?.stop(),
          onInteractionEnd: _handleInteractionEnd,
          trackpadScrollCausesScale: true,
          child: Builder(
            builder: (context) {
              final imageUrl = state.imageUrl;
              return SizedBox.expand(
                child: imageUrl == null
                    ? MediaFallback(media: widget.media)
                    : Image(
                        image: CachedNetworkImageProvider(imageUrl),
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => MediaFallback(media: widget.media),
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _TapListener extends StatefulWidget {
  const _TapListener({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_TapListener> createState() => _TapListenerState();
}

class _TapListenerState extends State<_TapListener> {
  Offset? _start;
  int _pointers = 0;
  bool _multiplePointers = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (event) {
        _pointers += 1;
        _multiplePointers = _multiplePointers || _pointers > 1;
        if (_pointers == 1) _start = event.position;
      },
      onPointerUp: (event) {
        final start = _start;
        final isTap = start != null && !_multiplePointers && (event.position - start).distance <= 8;
        _pointers = (_pointers - 1).clamp(0, 1000);
        if (_pointers == 0) _multiplePointers = false;
        _start = null;
        if (isTap) widget.onTap();
      },
      onPointerCancel: (_) {
        _pointers = (_pointers - 1).clamp(0, 1000);
        if (_pointers == 0) _multiplePointers = false;
        _start = null;
      },
      child: widget.child,
    );
  }
}
