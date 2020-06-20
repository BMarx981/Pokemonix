import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokemonix/models/poke.dart';
import 'package:pokemonix/models/ability_model.dart';

class Networking {
  final String mainUrl = 'https://pokeapi.co/api/v2/pokemon/';

  Future<Pokemon> getFunc(String pokeInput) async {
    var response = await http.get('$mainUrl${pokeInput.toLowerCase()}');
    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<AbilityModel> getAbilityResponse(String urlInput) async {
    var response = await http.get(urlInput);
    if (response.statusCode == 200) {
      return AbilityModel.fromJson(json.decode(response.body));
    }
  }
}
