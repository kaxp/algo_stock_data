// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'options_websocket_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionsWebSocketResponse _$OptionsWebSocketResponseFromJson(
        Map<String, dynamic> json) =>
    OptionsWebSocketResponse(
      ltp: (json['ltp'] as List<dynamic>?)
          ?.map((e) => LtpSocketData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OptionsWebSocketResponseToJson(
        OptionsWebSocketResponse instance) =>
    <String, dynamic>{
      'ltp': instance.ltp,
    };

LtpSocketData _$LtpSocketDataFromJson(Map<String, dynamic> json) =>
    LtpSocketData(
      token: json['token'] as String,
      ltp: (json['ltp'] as num).toDouble(),
    );

Map<String, dynamic> _$LtpSocketDataToJson(LtpSocketData instance) =>
    <String, dynamic>{
      'token': instance.token,
      'ltp': instance.ltp,
    };
