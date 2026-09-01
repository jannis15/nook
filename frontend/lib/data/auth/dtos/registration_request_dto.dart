import 'package:json_annotation/json_annotation.dart';

part 'registration_request_dto.g.dart';

/// A request to register a new account.
@JsonSerializable(createFactory: false)
class RegistrationRequestDto {
  /// Default constructor.
  const RegistrationRequestDto({required this.username, required this.email, required this.password});

  /// Converts this request to its API representation.
  Map<String, dynamic> toJson() => _$RegistrationRequestDtoToJson(this);

  /// The requested unique username.
  final String username;

  /// The account email address.
  final String email;

  /// The account password.
  final String password;
}
