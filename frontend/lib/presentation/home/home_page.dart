import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nook/config/app_breakpoints.dart';
import 'package:nook/domain/media/entities/media.dart';
import 'package:nook/domain/media/entities/media_failure.dart';
import 'package:nook/domain/media/entities/supported_media_file_types.dart';
import 'package:nook/domain/media/use_cases/list_media_use_case.dart';
import 'package:nook/domain/media/use_cases/upload_media_use_case.dart';
import 'package:nook/domain/media/use_cases/wait_for_media_status_use_case.dart';
import 'package:nook/presentation/app_bar/main_app_bar.dart';
import 'package:nook/presentation/home/cubit/home_cubit.dart';
import 'package:nook/presentation/home/cubit/home_presentation_event.dart';
import 'package:nook/presentation/home/cubit/home_state.dart';
import 'package:nook/presentation/home/models/media_library_item.dart';
import 'package:nook/presentation/home/widgets/floating_media_action_bar.dart';
import 'package:nook/presentation/home/widgets/media_library_action_bar.dart';
import 'package:nook/presentation/home/widgets/media_library_sliver.dart';
import 'package:nook/presentation/l10n/app_localizations_context.dart';
import 'package:nook/presentation/utils/app_notification.dart';
import 'package:nook/presentation/utils/build_context_layout.dart';

@RoutePage()
/// The media library landing page.
class HomePage extends StatelessWidget {
  /// Default constructor.
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit(
        listMedia: context.read<ListMediaUseCase>(),
        uploadMedia: context.read<UploadMediaUseCase>(),
        waitForMediaStatus: context.read<WaitForMediaStatusUseCase>(),
      ),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _scrollController = ScrollController();
  final _bodyKey = GlobalKey();
  final _inlineAddMediaButtonKey = GlobalKey();

  bool _isInlineAddMediaButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_updateInlineAddMediaButtonVisibility);
    _scrollController.addListener(_loadMoreMedia);
    unawaited(context.read<HomeCubit>().loadMedia());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _updateInlineAddMediaButtonVisibility() {
    final buttonContext = _inlineAddMediaButtonKey.currentContext;
    if (buttonContext == null) return;

    final box = buttonContext.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final top = box.localToGlobal(Offset.zero).dy;
    final bottom = top + box.size.height;
    final bodyBox = _bodyKey.currentContext?.findRenderObject() as RenderBox?;
    final bodyTop = bodyBox?.localToGlobal(Offset.zero).dy ?? 0;
    final bodyBottom = bodyTop + (bodyBox?.size.height ?? 0);
    final isVisible = bottom > bodyTop && top < bodyBottom;

    if (isVisible == _isInlineAddMediaButtonVisible) return;
    setState(() => _isInlineAddMediaButtonVisible = isVisible);
  }

  void _loadMoreMedia() {
    if (_scrollController.position.extentAfter < 400) {
      unawaited(context.read<HomeCubit>().loadMoreMedia());
    }
  }

  Future<void> _pickAndUploadMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: SupportedMediaFileTypes.extensions,
      allowMultiple: true,
      withData: true,
    );
    if (!mounted) return;

    final files = result?.files ?? const <PlatformFile>[];
    final pendingUploads = <PendingMediaLibraryItem>[];
    bool hasInvalidSelection = false;

    for (final file in files) {
      final bytes = file.bytes;
      final mimeType = SupportedMediaFileTypes.mimeTypeForFilename(file.name);
      if (bytes == null || mimeType == null) {
        hasInvalidSelection = true;
        continue;
      }

      pendingUploads.add(
        PendingMediaLibraryItem(
          id: 'pending-${DateTime.now().microsecondsSinceEpoch}-${file.name}',
          filename: file.name,
          mimeType: mimeType,
          fileSize: file.size,
          createdAt: DateTime.now(),
          mediaType: mimeType.startsWith('video/') ? MediaType.video : MediaType.image,
          bytes: bytes,
        ),
      );
    }

    if (hasInvalidSelection) {
      context.read<HomeCubit>().reportInvalidMediaSelection();
    }
    await context.read<HomeCubit>().uploadMedia(pendingUploads);
  }

  void _showFailure(MediaFailure failure) {
    final message = switch (failure) {
      UnauthenticatedMediaFailure() => context.l10n.mediaFailureUnauthenticated,
      InvalidMediaFailure() => context.l10n.mediaFailureUnsupported,
      UnknownMediaFailure() => context.l10n.mediaFailureUnknown,
    };

    showAppNotification(context, message, type: AppNotificationType.error);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateInlineAddMediaButtonVisibility();
      }
    });

    return BlocPresentationListener<HomeCubit, HomePresentationEvent>(
      listener: (context, event) {
        switch (event) {
          case HomeMediaOperationFailed(:final failure):
            _showFailure(failure);
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final items = switch (state) {
            HomeLoaded(:final items) => items,
            HomeLoading() || HomeError() => const <MediaLibraryItem>[],
          };
          final isLoading = state is HomeLoading;
          final hasError = state is HomeError;

          return switch (context.layoutMode) {
            AppLayoutMode.mobile => _buildMobileLayout(items: items, isLoading: isLoading, hasError: hasError),
            AppLayoutMode.web => _buildWebLayout(items: items, isLoading: isLoading, hasError: hasError),
          };
        },
      ),
    );
  }

  Widget _buildMobileLayout({required List<MediaLibraryItem> items, required bool isLoading, required bool hasError}) {
    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingMediaActionBar(
        layoutMode: AppLayoutMode.mobile,
        isVisible: !_isInlineAddMediaButtonVisible,
        isLoading: isLoading,
        onRefresh: () => unawaited(context.read<HomeCubit>().loadMedia()),
        onAddMedia: _pickAndUploadMedia,
      ),
      body: SafeArea(
        child: KeyedSubtree(
          key: _bodyKey,
          child: RefreshIndicator.adaptive(
            onRefresh: () => context.read<HomeCubit>().loadMedia(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  sliver: SliverToBoxAdapter(
                    child: MediaLibraryActionBar(
                      layoutMode: AppLayoutMode.mobile,
                      isLoading: isLoading,
                      addMediaButtonKey: _inlineAddMediaButtonKey,
                      onRefresh: () => unawaited(context.read<HomeCubit>().loadMedia()),
                      onAddMedia: _pickAndUploadMedia,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 96),
                  sliver: MediaLibrarySliver(
                    layoutMode: AppLayoutMode.mobile,
                    items: items,
                    isLoading: isLoading,
                    hasError: hasError,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebLayout({required List<MediaLibraryItem> items, required bool isLoading, required bool hasError}) {
    return Scaffold(
      appBar: const MainAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingMediaActionBar(
        layoutMode: AppLayoutMode.web,
        isVisible: !_isInlineAddMediaButtonVisible,
        isLoading: isLoading,
        onRefresh: () => unawaited(context.read<HomeCubit>().loadMedia()),
        onAddMedia: _pickAndUploadMedia,
      ),
      body: SafeArea(
        child: KeyedSubtree(
          key: _bodyKey,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverLayoutBuilder(
                builder: (context, constraints) {
                  final horizontalPadding = constraints.crossAxisExtent > AppBreakpoints.centredContent
                      ? (constraints.crossAxisExtent - AppBreakpoints.contentMaxWidth) / 2
                      : AppBreakpoints.contentHorizontalGutter;

                  return SliverMainAxisGroup(
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(horizontalPadding, 24, horizontalPadding, 32),
                        sliver: SliverToBoxAdapter(
                          child: MediaLibraryActionBar(
                            layoutMode: AppLayoutMode.web,
                            isLoading: isLoading,
                            addMediaButtonKey: _inlineAddMediaButtonKey,
                            onRefresh: () => unawaited(context.read<HomeCubit>().loadMedia()),
                            onAddMedia: _pickAndUploadMedia,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 88),
                        sliver: MediaLibrarySliver(
                          layoutMode: AppLayoutMode.web,
                          items: items,
                          isLoading: isLoading,
                          hasError: hasError,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
