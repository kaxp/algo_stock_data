import 'package:json_annotation/json_annotation.dart';

part 'option_chain_response.g.dart';

// Note: I'm only including the data from option chain
// API that is required for this task.
@JsonSerializable(explicitToJson: true)
class OptionChainResponse {
  final String candle;
  final String underlying;
  final Map<String, OptionData> options;

  @JsonKey(name: 'implied_futures')
  final Map<String, double> impliedFutures;

  OptionChainResponse({
    required this.candle,
    required this.underlying,
    required this.options,
    required this.impliedFutures,
  });

  factory OptionChainResponse.fromJson(Map<String, dynamic> json) =>
      _$OptionChainResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OptionChainResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OptionData {
  final List<double> strike;

  @JsonKey(name: 'call_close')
  final List<double?>? callClose;

  @JsonKey(name: 'put_close')
  final List<double?>? putClose;

  OptionData({
    required this.strike,
    this.callClose,
    this.putClose,
  });

  factory OptionData.fromJson(Map<String, dynamic> json) =>
      _$OptionDataFromJson(json);

  Map<String, dynamic> toJson() => _$OptionDataToJson(this);
}
