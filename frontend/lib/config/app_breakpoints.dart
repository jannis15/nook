/// Shared responsive layout breakpoints.
abstract final class AppBreakpoints {
  /// The maximum width for mobile layouts.
  static const mobile = 600.0;

  /// The maximum width of centred content.
  static const contentMaxWidth = 1180.0;

  /// The minimum horizontal gutter for content.
  static const contentHorizontalGutter = 24.0;

  /// The viewport width at which content becomes centred.
  static const centredContent = contentMaxWidth + 2 * contentHorizontalGutter;
}
