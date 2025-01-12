// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option_chain_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OptionChainResponse _$OptionChainResponseFromJson(Map<String, dynamic> json) =>
    OptionChainResponse(
      candle: json['candle'] as String,
      underlying: json['underlying'] as String,
      options: (json['options'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, OptionData.fromJson(e as Map<String, dynamic>)),
      ),
      impliedFutures: (json['implied_futures'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
    );

Map<String, dynamic> _$OptionChainResponseToJson(
        OptionChainResponse instance) =>
    <String, dynamic>{
      'candle': instance.candle,
      'underlying': instance.underlying,
      'options': instance.options.map((k, e) => MapEntry(k, e.toJson())),
      'implied_futures': instance.impliedFutures,
    };

OptionData _$OptionDataFromJson(Map<String, dynamic> json) => OptionData(
      strike: (json['strike'] as List<dynamic>)
          .map((e) => (e as num).toDouble())
          .toList(),
      callClose: (json['call_close'] as List<dynamic>?)
          ?.map((e) => (e as num?)?.toDouble())
          .toList(),
      putClose: (json['put_close'] as List<dynamic>?)
          ?.map((e) => (e as num?)?.toDouble())
          .toList(),
    );

Map<String, dynamic> _$OptionDataToJson(OptionData instance) =>
    <String, dynamic>{
      'strike': instance.strike,
      'call_close': instance.callClose,
      'put_close': instance.putClose,
    };
