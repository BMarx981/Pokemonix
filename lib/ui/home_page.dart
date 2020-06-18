import 'package:flutter/material.dart';
import 'package:pokemonix/models/poke.dart';
import 'package:pokemonix/utils/networking.dart';
import 'package:pokemonix/utils/names.dart';

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
                        height: 100,
                        width: 100,
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
    String name =
        data.name.replaceFirst(data.name[0], data.name[0].toUpperCase());
    double size = 300;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: size,
              width: size,
              child: Image(
                fit: BoxFit.fill,
                image: NetworkImage(data.sprites['front_default']),
              ),
            ),
            Text(
              '$name',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
