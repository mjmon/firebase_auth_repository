import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class User extends Equatable {
  /// {@macro user}
  const User(
      {@required this.id,
      @required this.email,
      @required this.name,
      @required this.photo})
      : assert(id != null),
        assert(email != null);

  /// The current user's id
  final String id;

  ///The current user's email address.
  final String email;

  /// The current user's name (display name)
  final String name;

  /// Url for the current user's photo
  final String photo;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '', email: '', name: null, photo: null);

  @override
  List<Object> get props {
    return [
      id,
      email,
      name,
      photo,
    ];
  }
}
