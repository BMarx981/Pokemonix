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
  List<Map<String, dynamic>> abilities;
  List<String> moves;
  Map<String, dynamic> species;
  List<String> evolutions;

  Pokemon({
    this.name,
    this.id,
    this.isMainSeries,
    this.sprites,
    this.generations,
    this.names,
    this.effectEntries,
    this.effectChanges,
    this.flavorTextChanges,
    this.abilities,
    this.moves,
    this.species,
    this.evolutions,
  });

  factory Pokemon.fromJson(Map<String, dynamic> parsedJson) {
    //Get Abilities
    List<Map<String, dynamic>> abilityNames = [];
    List<dynamic> abils = parsedJson['abilities'];
    abils.forEach((key) {
      abilityNames.add(key['ability']);
    });

    //Get move names
    List<String> moveNames = [];
    List<dynamic> parsedMoves = parsedJson['moves'] ?? 'nulled';
    parsedMoves.forEach((value) {
      Map<String, dynamic> moveObj = value['move'];
      var newName = moveObj['name'];
      moveNames.add(newName);
    });
    moveNames.sort();

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
      species: parsedJson['species'],
      abilities: abilityNames,
      moves: moveNames,
    );
  }
}
