import 'package:equatable/equatable.dart';

class GiphyMeta extends Equatable {
  final int status;
  final String msg;

  final String responseId;

  @override
  List<Object> get props => [status, msg, responseId];

  GiphyMeta({this.status, this.msg, this.responseId});

  factory GiphyMeta.fromJson(Map<String, dynamic> json) =>
      GiphyMeta(status: json['status'] as int, msg: json['msg'] as String, responseId: json['response_id'] as String);

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'status': status, 'msg': msg, 'response_id': responseId};
  }

  @override
  String toString() {
    return 'GiphyMeta{status: $status, msg: $msg, responseId: $responseId}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GiphyMeta && runtimeType == other.runtimeType && status == other.status && msg == other.msg && responseId == other.responseId;

  @override
  int get hashCode => status.hashCode ^ msg.hashCode ^ responseId.hashCode;
}
