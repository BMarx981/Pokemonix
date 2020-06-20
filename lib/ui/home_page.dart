import 'package:flutter/material.dart';
import 'package:pokemonix/models/poke.dart';
import 'package:pokemonix/utils/networking.dart';
import 'package:pokemonix/utils/names.dart';
import 'ability_page.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final Networking networking = Networking();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<Pokemon> futurePokemon;
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: ListView(
          children: <Widget>[
            TextField(
              keyboardType: TextInputType.text,
              controller: controller,
              autocorrect: false,
              onSubmitted: (value) => getPokemon(value),
              onChanged: (value) => names.contains(value),
              decoration: InputDecoration(
                hintText: 'Enter a Pokémon\'s name',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: futurePokemon,
                builder: (context, snapshot) {
                  Widget sender;
                  if (snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.done) {
                    sender = pokeWidget(snapshot.data);
                  } else if (snapshot.hasError) {
                    sender = Text(
                        '${snapshot.error}\nThat pokemon is not in the index.\nPlease try again.');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    sender = SizedBox(
                        height: 200,
                        width: 200,
                        child: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    sender = Container(child: Text(''));
                  }
                  return sender;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getPokemon(String value) async {
    Networking networking = Networking();
    setState(() {
      futurePokemon = networking.getFunc(value);
    });
  }

  Widget pokeWidget(data) {
    List<String> namesList = [];
    Map<String, String> abilityMap = {};
    data.abilities.forEach((info) {
      namesList.add(info['name']
          .replaceFirst(info['name'][0], info['name'][0].toUpperCase()));
      String n = info['name']
          .replaceFirst(info['name'][0], info['name'][0].toUpperCase());

      abilityMap[n] = info['url'];
    });
    print(abilityMap['name']);
    String name =
        data.name.replaceFirst(data.name[0], data.name[0].toUpperCase());
    double size = 300;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.amber, width: 1),
          borderRadius: BorderRadius.circular(35),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              '$name',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: size,
              width: size,
              child: Image(
                fit: BoxFit.fill,
                image: NetworkImage(data.sprites['front_default']),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.amber,
                  ),
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Abilities',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      //Abilities list
                      ListView.separated(
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 6),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: abilityMap.length,
                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(35),
                              color: Colors.grey[200],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(6),
                              title: Text(
                                '  ${namesList[index]}',
                                style: TextStyle(fontSize: 20),
                              ),
                              //abilityMap[namesList[index]]
                              trailing: Text('see more...  '),
                              onTap: () {
                                getAbility();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AbilityPage(),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void getAbility() {}
}
