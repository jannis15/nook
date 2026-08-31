/// A failure encountered while operating on media.
sealed class MediaFailure {
  /// Default constructor.
  const MediaFailure();
}

/// The current session cannot access media.
final class UnauthenticatedMediaFailure extends MediaFailure {
  /// Default constructor.
  const UnauthenticatedMediaFailure();
}

/// The requested media no longer exists.
final class MediaNotFoundFailure extends MediaFailure {
  /// Default constructor.
  const MediaNotFoundFailure();
}

/// The media input is invalid.
final class InvalidMediaFailure extends MediaFailure {
  /// Default constructor.
  const InvalidMediaFailure([this.message]);

  /// Additional validation detail, when provided.
  final String? message;
}

/// An unexpected media operation failure.
final class UnknownMediaFailure extends MediaFailure {
  /// Default constructor.
  const UnknownMediaFailure();
}
