import 'package:flutter/widgets.dart';
import 'package:nook/presentation/l10n/generated/app_localizations.dart';

/// Provides localisation access from a build context.
extension AppLocalizationsContext on BuildContext {
  /// The localisations for this context.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
