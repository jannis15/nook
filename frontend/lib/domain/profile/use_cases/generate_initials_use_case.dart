class GenerateInitialsUseCase {
  const GenerateInitialsUseCase();

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
