import 'package:flutter/material.dart';
import 'package:pokemonix/models/ability_model.dart';
import 'package:pokemonix/utils/networking.dart';

class AbilityPage extends StatefulWidget {
  final String name;
  final String ability;
  final String url;

  AbilityPage({this.name, this.url, this.ability});

  @override
  _AbilityPageState createState() => _AbilityPageState();
}

class _AbilityPageState extends State<AbilityPage> {
  Future<AbilityModel> futureAbility;

  @override
  void initState() {
    getAbility(widget.url);
    super.initState();
  }

  void getAbility(String u) {
    Networking networking = Networking();
    setState(() {
      futureAbility = networking.getAbilityResponse(u);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Other Pokémon with ${this.widget.name}',
          maxLines: 2,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: futureAbility,
            builder: (context, snapshot) {
              var ret;
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                List<String> names = [];
                snapshot.data.pokemonChar.forEach((value) {
                  Language n = value.pokemonChar;
                  names.add(n.name);
                });
                ret = FinishedProduct(names: names);
              } else if (snapshot.hasError) {
                ret = Container(
                  child:
                      Text('${snapshot.error}\n Failed to load the abilities.'),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                ret = Center(
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.none) {
                ret = Container(
                  child: Text('Nope'),
                );
              }
              return ret;
            },
          ),
        ),
      ),
    );
  }
}

class FinishedProduct extends StatelessWidget {
  const FinishedProduct({
    Key key,
    @required this.names,
  }) : super(key: key);

  final List<String> names;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: names.length,
        itemBuilder: (context, index) {
          String name = names[index]
              .replaceFirst(names[index][0], names[index][0].toUpperCase());
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(name,
                    style: TextStyle(
                      fontSize: 16,
                    )),
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black, offset: Offset(1, 1)),
                  BoxShadow(color: Colors.grey, offset: Offset(1, 1)),
                ],
                color: Colors.grey[200],
                border: Border.all(
                  color: Colors.amber,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(35),
              ),
            ),
          );
        },
      ),
    );
  }
}
