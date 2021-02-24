class PredictionModel {
  final String disease;
  final double prediction;

  PredictionModel({this.disease, this.prediction});

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
        disease: json['disease'], prediction: json['prediction']);
  }

  @override
  String toString(){
    return "{disease: $disease, prediction: $prediction}";
  }
}
