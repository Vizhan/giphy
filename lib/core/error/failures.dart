import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class ServerFailure extends Failure {
  final int statusCode;
  final String exception;

  ServerFailure(this.statusCode, this.exception);

  @override
  List<Object> get props => [statusCode, exception];
}
