import 'package:json_annotation/json_annotation.dart';

part 'contracts_response.g.dart';

// Note: I'm only including the data from contracts
// API that is required for this task.
@JsonSerializable(explicitToJson: true)
class ContractsResponse {
  ContractsResponse({
    required this.contracts,
  });

  @JsonKey(name: 'BANKNIFTY')
  final ContractsData contracts;

  // Token Cache
  late final Map<String, ContractOptionData> tokenCache = _buildTokenCache();

  factory ContractsResponse.fromJson(Map<String, dynamic> json) =>
      _$ContractsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ContractsResponseToJson(this);

  /// Build token-to-optioncontract lookup cache
  ///
  /// Example cache object:
  ///
  /// 'NSE_36794': {
  ///   "token": "NSE_36794",
  ///   "symbol": "BANKNIFTY25FEB42000PE",
  ///   "lot_size": 30,
  ///   "tick_size": 5,
  ///   "max_qty_in_order": 900,
  ///   "expiry": "2025-02-27",
  ///   "strike": 42000.0,
  ///   "underlying": "BANKNIFTY",
  ///   "instrument_type": "OPT",
  ///   "option_type": "PE",
  ///   "exchange": "NSE",
  ///   "is_tradable": true
  /// }
  Map<String, ContractOptionData> _buildTokenCache() {
    final Map<String, ContractOptionData> cache = {};
    contracts.contractOptions.forEach((expiry, options) {
      for (var option in options) {
        cache[option.token] = option; // Map token to the contract data
      }
    });
    return cache;
  }
}

@JsonSerializable(explicitToJson: true)
class ContractsData {
  const ContractsData({
    required this.contractOptions,
  });

  @JsonKey(name: 'OPT')
  final Map<String, List<ContractOptionData>> contractOptions;

  factory ContractsData.fromJson(Map<String, dynamic> json) =>
      _$ContractsDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContractsDataToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ContractOptionData {
  const ContractOptionData({
    required this.token,
    required this.expiry,
    required this.optionType,
  });

  final String token;
  final String expiry;

  /// [optionType] is the value that indicates type of
  /// option (i.e, PE or CE)
  ///
  /// optionType = PE indicates it's Put
  /// optionType = CE indicates it's Call
  @JsonKey(name: 'option_type')
  final String optionType;

  factory ContractOptionData.fromJson(Map<String, dynamic> json) =>
      _$ContractOptionDataFromJson(json);

  Map<String, dynamic> toJson() => _$ContractOptionDataToJson(this);
}
