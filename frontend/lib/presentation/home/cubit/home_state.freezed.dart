// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HomeState {}

/// @nodoc
class HomeLoading extends HomeState {
  const HomeLoading() : super._();

  @override
  bool operator ==(Object other) => identical(this, other) || (other.runtimeType == runtimeType && other is HomeLoading);

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() => 'HomeState.loading()';
}

/// @nodoc
class HomeLoaded extends HomeState {
  const HomeLoaded({this.items = const <MediaLibraryItem>[]}) : super._();

  final List<MediaLibraryItem> items;

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is HomeLoaded && other.items == items);
  }

  @override
  int get hashCode => Object.hash(runtimeType, items);

  @override
  String toString() => 'HomeState.loaded(items: $items)';
}

/// @nodoc
class HomeError extends HomeState {
  const HomeError({required this.failure}) : super._();

  final MediaFailure failure;

  @override
  bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType && other is HomeError && other.failure == failure);
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  @override
  String toString() => 'HomeState.error(failure: $failure)';
}
