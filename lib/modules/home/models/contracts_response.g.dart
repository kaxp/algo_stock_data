// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contracts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContractsResponse _$ContractsResponseFromJson(Map<String, dynamic> json) =>
    ContractsResponse(
      contracts:
          ContractsData.fromJson(json['BANKNIFTY'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ContractsResponseToJson(ContractsResponse instance) =>
    <String, dynamic>{
      'BANKNIFTY': instance.contracts.toJson(),
    };

ContractsData _$ContractsDataFromJson(Map<String, dynamic> json) =>
    ContractsData(
      contractOptions: (json['OPT'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) =>
                    ContractOptionData.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
    );

Map<String, dynamic> _$ContractsDataToJson(ContractsData instance) =>
    <String, dynamic>{
      'OPT': instance.contractOptions
          .map((k, e) => MapEntry(k, e.map((e) => e.toJson()).toList())),
    };

ContractOptionData _$ContractOptionDataFromJson(Map<String, dynamic> json) =>
    ContractOptionData(
      token: json['token'] as String,
      expiry: json['expiry'] as String,
      optionType: json['option_type'] as String,
    );

Map<String, dynamic> _$ContractOptionDataToJson(ContractOptionData instance) =>
    <String, dynamic>{
      'token': instance.token,
      'expiry': instance.expiry,
      'option_type': instance.optionType,
    };
