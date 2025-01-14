import 'package:json_annotation/json_annotation.dart';

part 'option_chain_response.g.dart';

@JsonSerializable(explicitToJson: true)
class OptionChainResponse {
  const OptionChainResponse({
    required this.candle,
    required this.underlying,
    required this.options,
    required this.impliedFutures,
  });

  final String candle;
  final String underlying;
  final Map<String, OptionData> options;

  @JsonKey(name: 'implied_futures')
  final Map<String, double> impliedFutures;

  factory OptionChainResponse.fromJson(Map<String, dynamic> json) =>
      _$OptionChainResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OptionChainResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class OptionData {
  const OptionData({
    required this.options,
  });

  /// We are updating the API response from a Map
  /// having 3 seperate lists
  /// {
  ///   'strike':[],
  ///   'call_close':[].
  ///   'put_close':[]
  /// }
  /// to a List [options] that holds the data of each
  /// strike's row together
  ///
  /// [
  ///   {
  ///     'strike' : 0.0,
  ///     'call_close' : 0.0,
  ///     'put_close' : 0.0,
  ///   }
  /// ]
  ///
  /// This helps us in better state updation on UI when
  /// the new values of call/put ltp comes in web
  /// socket response.
  final List<Option> options;

  factory OptionData.fromJson(Map<String, dynamic> json) {
    List<Option> optionsList = [];
    var strikes = List<double>.from(json['strike']);
    var callClose = List<double?>.from(json['call_close']);
    var putClose = List<double?>.from(json['put_close']);

    // Combine corresponding elements from strike,
    // call_close, and put_close into Option objects
    for (int i = 0; i < strikes.length; i++) {
      optionsList.add(Option(
        strike: strikes[i],
        callClose: callClose[i],
        putClose: putClose[i],
      ));
    }

    return OptionData(options: optionsList);
  }

  Map<String, dynamic> toJson() => _$OptionDataToJson(this);
}

@JsonSerializable()
class Option {
  final double strike;
  double? callClose;
  double? putClose;

  Option({
    required this.strike,
    this.callClose,
    this.putClose,
  });

  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);

  Map<String, dynamic> toJson() => _$OptionToJson(this);
}
