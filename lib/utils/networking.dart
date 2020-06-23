import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pokemonix/models/poke.dart';
import 'package:pokemonix/models/ability_model.dart';

class Networking {
  final String mainUrl = 'https://pokeapi.co/api/v2/pokemon/';

  Future<Pokemon> getFunc(String pokeInput) async {
    var response = await http.get('$mainUrl${pokeInput.toLowerCase().trim()}');
    if (response.statusCode == 200) {
      var p = Pokemon.fromJson(json.decode(response.body));
      Map<String, dynamic> species = p.species;
      var nextResponse = await http.get(species['url']);
      if (nextResponse.statusCode == 200) {
        var evolChain = json.decode(nextResponse.body)['evolution_chain'];
        var chainresponse = await http.get(evolChain['url']);
        if (chainresponse.statusCode == 200) {
          var chain = json.decode(chainresponse.body)['chain'];
          print(chain);
        }
      }
      return p;
    } else {
      throw Exception('Failed to load');
    }
  }

  Future<AbilityModel> getAbilityResponse(String urlInput) async {
    var response = await http.get(urlInput);
    if (response.statusCode == 200) {
      return AbilityModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load abilities');
    }
  }

  Future<List<String>> getEvolutions(String input) async {
    var response = await http.get(input);
    // List<String> list = [];
    if (response.statusCode == 200) {
      var j = json.decode(response.body);
      print(j);
      return j;
    }
  }
}
