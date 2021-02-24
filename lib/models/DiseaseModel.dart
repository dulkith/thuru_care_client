class DiseaseModel {
  final String key;
  final String name;
  final String category;
  final String plant;
  final String imageTitle;
  final String synonyms;
  final String definition;
  final String symptoms;
  final String trigger;
  final List<String> priventiveMesures;
  final String biologicalControl;
  final String chemicalControl;
  final String traditionalControl;

  DiseaseModel({
      this.key,
      this.name,
      this.category,
      this.plant,
      this.imageTitle,
      this.synonyms,
      this.definition,
      this.symptoms,
      this.trigger,
      this.priventiveMesures,
      this.chemicalControl,
      this.traditionalControl,
      this.biologicalControl});

  factory DiseaseModel.fromJson(Map<String, dynamic> json) {
    return DiseaseModel(
        key: json['key'],
        name: json['name'],
        category: json['category'],
        plant: json['plant'],
        imageTitle: json['imageTitle'],
        synonyms: json['synonyms'],
        definition: json['definition'],
        symptoms: json['symptoms'],
        trigger: json['trigger'],
        priventiveMesures: json['priventiveMesures'].cast<String>(),
        biologicalControl: json['biologicalControl'],
        chemicalControl: json['chemicalControl'],
        traditionalControl: json['traditionalControl']);
  }
}
