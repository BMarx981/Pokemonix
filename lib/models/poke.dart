import 'dart:core';

class Pokemon {
  String name;
  int id;
  bool isMainSeries;
  Map<String, dynamic> sprites;
  Map<String, String> generations;
  List<String> names;
  List<String> effectEntries;
  List<String> effectChanges;
  List<String> flavorTextChanges;

  Pokemon(
      {this.name,
      this.id,
      this.isMainSeries,
      this.sprites,
      this.generations,
      this.names,
      this.effectEntries,
      this.effectChanges,
      this.flavorTextChanges});

  factory Pokemon.fromJson(Map<String, dynamic> parsedJson) {
    return Pokemon(
      name: parsedJson['name'],
      id: parsedJson['id'],
      isMainSeries: parsedJson['is_main_series'],
      sprites: parsedJson['sprites'],
      generations: parsedJson['is_main_series'],
      names: parsedJson['generations'],
      effectEntries: parsedJson['effect_entries'],
      effectChanges: parsedJson['effect_changes'],
      flavorTextChanges: parsedJson['flavor_text_entries'],
    );
  }
}
