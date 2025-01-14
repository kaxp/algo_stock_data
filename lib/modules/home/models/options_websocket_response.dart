import 'package:json_annotation/json_annotation.dart';

part 'options_websocket_response.g.dart';

// Note: I'm only including the data from contracts
// API that is required for this task.
@JsonSerializable()
class OptionsWebSocketResponse {
  const OptionsWebSocketResponse({
    required this.ltp,
    required this.errorMessage,
  });

  final List<LtpSocketData>? ltp;
  final String? errorMessage;

  factory OptionsWebSocketResponse.fromJson(Map<String, dynamic> json) =>
      _$OptionsWebSocketResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OptionsWebSocketResponseToJson(this);
}

@JsonSerializable()
class LtpSocketData {
  const LtpSocketData({
    required this.token,
    required this.ltp,
  });

  final String token;
  final double ltp;

  factory LtpSocketData.fromJson(Map<String, dynamic> json) =>
      _$LtpSocketDataFromJson(json);

  Map<String, dynamic> toJson() => _$LtpSocketDataToJson(this);
}
