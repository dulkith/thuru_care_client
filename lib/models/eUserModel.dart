/* class Location {
  final double longitude;
  final double latitude;

  Location({this.latitude, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(longitude: json['longitude'], latitude: json['latitude']);
  }
}

class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String telNumber;
  final String gender;
  final Location location;

  UserModel(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.password,
      this.telNumber,
      this.gender,
      this.location});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        email: json['email'],
        password: json['password'],
        telNumber: json['telNumber'],
        gender: json['gender'],
        location: Location.fromJson(json['location']));
  }
}
 */