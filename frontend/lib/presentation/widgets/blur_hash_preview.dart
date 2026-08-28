import 'dart:typed_data';

import 'package:blurhash/blurhash.dart';
import 'package:flutter/material.dart';

/// Renders a BlurHash once decoding has completed.
class BlurHashPreview extends StatefulWidget {
  /// Default constructor.
  const BlurHashPreview({super.key, required this.hash, required this.fallback, this.fit = BoxFit.cover});

  /// The BlurHash to decode.
  final String hash;

  /// Content to show when decoding fails.
  final Widget fallback;

  /// How the decoded image fills its bounds.
  final BoxFit fit;

  @override
  State<BlurHashPreview> createState() => _BlurHashPreviewState();
}

class _BlurHashPreviewState extends State<BlurHashPreview> {
  late Future<Uint8List?> _imageBytes;

  @override
  void initState() {
    super.initState();
    _imageBytes = _decodeBlurHash(widget.hash);
  }

  @override
  void didUpdateWidget(covariant BlurHashPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.hash != widget.hash) {
      _imageBytes = _decodeBlurHash(widget.hash);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _imageBytes,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SizedBox.expand();
        }
        final imageBytes = snapshot.data;
        return imageBytes == null ? widget.fallback : Image.memory(imageBytes, fit: widget.fit);
      },
    );
  }

  Future<Uint8List?> _decodeBlurHash(String hash) async {
    try {
      return await BlurHash.decode(hash, 32, 24);
    } on Object {
      return null;
    }
  }
}
