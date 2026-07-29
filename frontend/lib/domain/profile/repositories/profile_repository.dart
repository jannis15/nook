import 'package:nook/domain/profile/entities/app_profile.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class ProfileRepository {
  ValueStream<AppProfile?> get ownProfile;
}
