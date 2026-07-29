import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/domain/auth/use_cases/logout_use_case.dart';
import 'package:nook/domain/profile/use_cases/watch_own_profile_use_case.dart';
import 'package:nook/presentation/app_bar/main_app_bar_cubit.dart';
import 'package:nook/presentation/app_bar/main_app_bar_presentation_event.dart';
import 'package:nook/presentation/app_bar/main_app_bar_state.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/app_notification.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainAppBarCubit(
        watchOwnProfile: context.read<WatchOwnProfileUseCase>(),
        logout: context.read<LogoutUseCase>(),
      ),
      child:
          BlocPresentationListener<
            MainAppBarCubit,
            MainAppBarPresentationEvent
          >(
            listener: (context, event) {
              switch (event) {
                case MainAppBarLogoutFailed():
                  showAppNotification(
                    context,
                    context.l10n.homeLogoutFailedError,
                    type: AppNotificationType.error,
                  );
              }
            },
            child: AppBar(
              title: const Text('Home'),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: _ProfileMenuButton(),
                ),
              ],
            ),
          ),
    );
  }
}

class _ProfileMenuButton extends StatefulWidget {
  const _ProfileMenuButton();

  @override
  State<_ProfileMenuButton> createState() => _ProfileMenuButtonState();
}

class _ProfileMenuButtonState extends State<_ProfileMenuButton> {
  final _layerLink = LayerLink();
  OverlayEntry? _menuOverlay;

  @override
  void dispose() {
    _hideMenu();
    super.dispose();
  }

  void _toggleMenu(MainAppBarState state) {
    if (_menuOverlay == null) {
      _showMenu(state);
      return;
    }

    _hideMenu();
  }

  void _showMenu(MainAppBarState state) {
    final overlay = Overlay.of(context);
    final cubit = context.read<MainAppBarCubit>();

    _menuOverlay = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _hideMenu,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              targetAnchor: Alignment.bottomRight,
              followerAnchor: Alignment.topRight,
              offset: const Offset(0, 8),
              child: _ProfileMenu(
                state: state,
                onLogout: () {
                  _hideMenu();
                  unawaited(cubit.logout());
                },
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_menuOverlay!);
  }

  void _hideMenu() {
    _menuOverlay?.remove();
    _menuOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainAppBarCubit, MainAppBarState>(
      builder: (context, state) {
        final user = state.user;

        if (user == null) {
          return const SizedBox.shrink();
        }

        return CompositedTransformTarget(
          link: _layerLink,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: state.isLoggingOut ? null : () => _toggleMenu(state),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _UserAvatar(initials: user.initials, size: 32),
                    const SizedBox(width: 6),
                    const Icon(Icons.keyboard_arrow_down_rounded),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ProfileMenu extends StatelessWidget {
  const _ProfileMenu({required this.state, required this.onLogout});

  final MainAppBarState state;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final user = state.user;

    if (user == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 280,
      child: Material(
        color: colorScheme.surface,
        elevation: 12,
        shadowColor: colorScheme.shadow.withValues(alpha: 0.14),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    _UserAvatar(initials: user.initials, size: 44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                          if (user.email != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              user.email!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: colorScheme.outlineVariant),
              const SizedBox(height: 8),
              _ProfileMenuItem(
                icon: Icons.logout_rounded,
                label: context.l10n.homeLogoutButton,
                isLoading: state.isLoggingOut,
                onTap: state.isLoggingOut ? null : onLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
            if (isLoading)
              const SizedBox.square(
                dimension: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.initials, required this.size});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      child: Text(initials),
    );
  }
}
