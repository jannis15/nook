// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'main_app_bar_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MainAppBarState {

 MainAppBarUser? get user; bool get isLoggingOut;
/// Create a copy of MainAppBarState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainAppBarStateCopyWith<MainAppBarState> get copyWith => _$MainAppBarStateCopyWithImpl<MainAppBarState>(this as MainAppBarState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainAppBarState&&(identical(other.user, user) || other.user == user)&&(identical(other.isLoggingOut, isLoggingOut) || other.isLoggingOut == isLoggingOut));
}


@override
int get hashCode => Object.hash(runtimeType,user,isLoggingOut);

@override
String toString() {
  return 'MainAppBarState(user: $user, isLoggingOut: $isLoggingOut)';
}


}

/// @nodoc
abstract mixin class $MainAppBarStateCopyWith<$Res>  {
  factory $MainAppBarStateCopyWith(MainAppBarState value, $Res Function(MainAppBarState) _then) = _$MainAppBarStateCopyWithImpl;
@useResult
$Res call({
 MainAppBarUser? user, bool isLoggingOut
});


$MainAppBarUserCopyWith<$Res>? get user;

}
/// @nodoc
class _$MainAppBarStateCopyWithImpl<$Res>
    implements $MainAppBarStateCopyWith<$Res> {
  _$MainAppBarStateCopyWithImpl(this._self, this._then);

  final MainAppBarState _self;
  final $Res Function(MainAppBarState) _then;

/// Create a copy of MainAppBarState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = freezed,Object? isLoggingOut = null,}) {
  return _then(_self.copyWith(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MainAppBarUser?,isLoggingOut: null == isLoggingOut ? _self.isLoggingOut : isLoggingOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MainAppBarState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainAppBarUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $MainAppBarUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [MainAppBarState].
extension MainAppBarStatePatterns on MainAppBarState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MainAppBarState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MainAppBarState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MainAppBarState value)  $default,){
final _that = this;
switch (_that) {
case _MainAppBarState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MainAppBarState value)?  $default,){
final _that = this;
switch (_that) {
case _MainAppBarState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MainAppBarUser? user,  bool isLoggingOut)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MainAppBarState() when $default != null:
return $default(_that.user,_that.isLoggingOut);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MainAppBarUser? user,  bool isLoggingOut)  $default,) {final _that = this;
switch (_that) {
case _MainAppBarState():
return $default(_that.user,_that.isLoggingOut);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MainAppBarUser? user,  bool isLoggingOut)?  $default,) {final _that = this;
switch (_that) {
case _MainAppBarState() when $default != null:
return $default(_that.user,_that.isLoggingOut);case _:
  return null;

}
}

}

/// @nodoc


class _MainAppBarState extends MainAppBarState {
  const _MainAppBarState({required this.user, this.isLoggingOut = false}): super._();


@override final  MainAppBarUser? user;
@override@JsonKey() final  bool isLoggingOut;

/// Create a copy of MainAppBarState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainAppBarStateCopyWith<_MainAppBarState> get copyWith => __$MainAppBarStateCopyWithImpl<_MainAppBarState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainAppBarState&&(identical(other.user, user) || other.user == user)&&(identical(other.isLoggingOut, isLoggingOut) || other.isLoggingOut == isLoggingOut));
}


@override
int get hashCode => Object.hash(runtimeType,user,isLoggingOut);

@override
String toString() {
  return 'MainAppBarState(user: $user, isLoggingOut: $isLoggingOut)';
}


}

/// @nodoc
abstract mixin class _$MainAppBarStateCopyWith<$Res> implements $MainAppBarStateCopyWith<$Res> {
  factory _$MainAppBarStateCopyWith(_MainAppBarState value, $Res Function(_MainAppBarState) _then) = __$MainAppBarStateCopyWithImpl;
@override @useResult
$Res call({
 MainAppBarUser? user, bool isLoggingOut
});


@override $MainAppBarUserCopyWith<$Res>? get user;

}
/// @nodoc
class __$MainAppBarStateCopyWithImpl<$Res>
    implements _$MainAppBarStateCopyWith<$Res> {
  __$MainAppBarStateCopyWithImpl(this._self, this._then);

  final _MainAppBarState _self;
  final $Res Function(_MainAppBarState) _then;

/// Create a copy of MainAppBarState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = freezed,Object? isLoggingOut = null,}) {
  return _then(_MainAppBarState(
user: freezed == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as MainAppBarUser?,isLoggingOut: null == isLoggingOut ? _self.isLoggingOut : isLoggingOut // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MainAppBarState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MainAppBarUserCopyWith<$Res>? get user {
    if (_self.user == null) {
    return null;
  }

  return $MainAppBarUserCopyWith<$Res>(_self.user!, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

/// @nodoc
mixin _$MainAppBarUser {

 String get id; String? get displayName; String get email;
/// Create a copy of MainAppBarUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MainAppBarUserCopyWith<MainAppBarUser> get copyWith => _$MainAppBarUserCopyWithImpl<MainAppBarUser>(this as MainAppBarUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MainAppBarUser&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,email);

@override
String toString() {
  return 'MainAppBarUser(id: $id, displayName: $displayName, email: $email)';
}


}

/// @nodoc
abstract mixin class $MainAppBarUserCopyWith<$Res>  {
  factory $MainAppBarUserCopyWith(MainAppBarUser value, $Res Function(MainAppBarUser) _then) = _$MainAppBarUserCopyWithImpl;
@useResult
$Res call({
 String id, String? displayName, String email
});




}
/// @nodoc
class _$MainAppBarUserCopyWithImpl<$Res>
    implements $MainAppBarUserCopyWith<$Res> {
  _$MainAppBarUserCopyWithImpl(this._self, this._then);

  final MainAppBarUser _self;
  final $Res Function(MainAppBarUser) _then;

/// Create a copy of MainAppBarUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = freezed,Object? email = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [MainAppBarUser].
extension MainAppBarUserPatterns on MainAppBarUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MainAppBarUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MainAppBarUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MainAppBarUser value)  $default,){
final _that = this;
switch (_that) {
case _MainAppBarUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MainAppBarUser value)?  $default,){
final _that = this;
switch (_that) {
case _MainAppBarUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? displayName,  String email)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MainAppBarUser() when $default != null:
return $default(_that.id,_that.displayName,_that.email);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? displayName,  String email)  $default,) {final _that = this;
switch (_that) {
case _MainAppBarUser():
return $default(_that.id,_that.displayName,_that.email);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? displayName,  String email)?  $default,) {final _that = this;
switch (_that) {
case _MainAppBarUser() when $default != null:
return $default(_that.id,_that.displayName,_that.email);case _:
  return null;

}
}

}

/// @nodoc


class _MainAppBarUser extends MainAppBarUser {
  const _MainAppBarUser({required this.id, required this.displayName, required this.email}): super._();


@override final  String id;
@override final  String? displayName;
@override final  String email;

/// Create a copy of MainAppBarUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MainAppBarUserCopyWith<_MainAppBarUser> get copyWith => __$MainAppBarUserCopyWithImpl<_MainAppBarUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MainAppBarUser&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,email);

@override
String toString() {
  return 'MainAppBarUser(id: $id, displayName: $displayName, email: $email)';
}


}

/// @nodoc
abstract mixin class _$MainAppBarUserCopyWith<$Res> implements $MainAppBarUserCopyWith<$Res> {
  factory _$MainAppBarUserCopyWith(_MainAppBarUser value, $Res Function(_MainAppBarUser) _then) = __$MainAppBarUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String? displayName, String email
});




}
/// @nodoc
class __$MainAppBarUserCopyWithImpl<$Res>
    implements _$MainAppBarUserCopyWith<$Res> {
  __$MainAppBarUserCopyWithImpl(this._self, this._then);

  final _MainAppBarUser _self;
  final $Res Function(_MainAppBarUser) _then;

/// Create a copy of MainAppBarUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = freezed,Object? email = null,}) {
  return _then(_MainAppBarUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: freezed == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String?,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
