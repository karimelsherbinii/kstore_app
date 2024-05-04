import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final String? message;

  const ServerException([this.message]);

  @override
  List<Object?> get props => [message];

  @override
  String toString() {
    return '$message';
  }
}

class FetchDataException extends ServerException {
  const FetchDataException([message]) : super("Error During Communication");
}

class BadRequestException extends ServerException {
  const BadRequestException([message]) : super("Bad Request");
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException([message]) : super("Unauthorized");
}

class NotFoundException extends ServerException {
  const NotFoundException([message]) : super("Requested Info Not Found");
}

class ConflictException extends ServerException {
  const ConflictException([message]) : super("Conflict Occurred");
}

class InternalServerErrorException extends ServerException {
  const InternalServerErrorException([message])
      : super("Internal Server Error");
}

// 301 status code
class MovedPermanentlyException extends ServerException {
  const MovedPermanentlyException([message]) : super("Moved Permanently");
}

// 302 status code
class FoundException extends ServerException {
  const FoundException([message]) : super("This Data is already exist");
}

// 303 status code
class SeeOtherException extends ServerException {
  const SeeOtherException([message]) : super("See Other");
}

class NoInternetConnectionException extends ServerException {
  const NoInternetConnectionException([message])
      : super("No Internet Connection");
}

class CacheException implements Exception {}
