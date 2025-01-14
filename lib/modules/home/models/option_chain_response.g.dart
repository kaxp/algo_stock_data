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
      options: (json['options'] as List<dynamic>)
          .map((e) => Option.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OptionDataToJson(OptionData instance) =>
    <String, dynamic>{
      'options': instance.options.map((e) => e.toJson()).toList(),
    };

Option _$OptionFromJson(Map<String, dynamic> json) => Option(
      strike: (json['strike'] as num).toDouble(),
      callClose: (json['callClose'] as num?)?.toDouble(),
      putClose: (json['putClose'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$OptionToJson(Option instance) => <String, dynamic>{
      'strike': instance.strike,
      'callClose': instance.callClose,
      'putClose': instance.putClose,
    };
