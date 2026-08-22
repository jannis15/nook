/// Generates a compact initials string from a display name.
class GenerateInitialsUseCase {
  /// Default constructor.
  const GenerateInitialsUseCase();

  /// Returns up to two uppercase initials for [value].
  String call(String value) {
    final initials = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();

    if (initials.isEmpty) {
      return '?';
    }

    return initials;
  }
}
