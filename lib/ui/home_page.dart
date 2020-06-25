import 'package:flutter/material.dart';
import 'package:pokemonix/models/poke.dart';
import 'package:pokemonix/utils/networking.dart';
import 'package:pokemonix/utils/names.dart';
import 'ability_page.dart';
import 'package:motion_widget/motion_widget.dart';

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

  void getPokemon(String value) {
    Networking networking = Networking();
    setState(() {
      futurePokemon = networking.getFunc(value);
    });
  }

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
                    // if everything looks good build the pokeWidget.
                    sender = pokeWidget(snapshot.data);
                  } else if (snapshot.hasError) {
                    sender = Text(
                        '${snapshot.error}\nThat pokemon is not in the index.\nPlease try again.');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    sender = SizedBox(
                      height: 200,
                      width: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
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

  Widget pokeWidget(data) {
    List<String> evols = data.evolutions;
    String name =
        data.name.replaceFirst(data.name[0], data.name[0].toUpperCase());
    double size = 300;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Motion<Column>(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MotionElement(
              child: Text(
                '$name',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              orientation: MotionOrientation.RIGHT,
              interval: Interval(0.0, 0.75),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber, width: 1),
                borderRadius: BorderRadius.circular(35),
                boxShadow: [
                  BoxShadow(color: Colors.purple, offset: Offset(2, 2)),
                  BoxShadow(color: Colors.pink, offset: Offset(2, 2)),
                ],
                color: Color(0xffefefef),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  image: AssetImage(
                    // 'assets/images/rockPic.jpg',
                    'assets/images/pokeball_PNG32.png',
                  ),
                ),
              ),
              clipBehavior: Clip.hardEdge,
              height: size,
              width: size,
              child: Motion<Row>(
                children: <Widget>[
                  MotionElement(
                    mode: MotionMode.FADE,
                    interval: Interval(0.3, 0.9),
                    orientation: MotionOrientation.LEFT,
                    child: Image(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        data.sprites['front_default'],
                        scale: .1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            getEvolutionWidget(evols, data),
            getAbilitiesWidget(data),
            getMovesWidget(data),
          ],
        ),
      ),
    );
  }

  Widget getEvolutionWidget(List<String> evols, data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.purple, offset: Offset(2, 2)),
              BoxShadow(color: Colors.pink, offset: Offset(2, 2)),
            ],
            color: Color(0xffefefef),
            border: Border.all(color: Colors.amber, width: 1),
            borderRadius: BorderRadius.circular(35),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Evolutions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(color: Colors.purple, offset: Offset(1, 1)),
                          BoxShadow(color: Colors.pink, offset: Offset(1, 1)),
                        ],
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.amber,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(35),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(6),
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${evols[index].replaceFirst(evols[index][0], evols[index][0].toUpperCase())}',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        onTap: () {
                          controller.text = evols[index];
                          getPokemon(evols[index]);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemCount: data.evolutions.length,
                ),
              ],
            ),
          )),
    );
  }

  Widget getAbilitiesWidget(dynamic data) {
    List<String> namesList = [];
    Map<String, String> abilityMap = {};
    data.abilities.forEach((info) {
      namesList.add(info['name']
          .replaceFirst(info['name'][0], info['name'][0].toUpperCase()));
      String n = info['name']
          .replaceFirst(info['name'][0], info['name'][0].toUpperCase());

      abilityMap[n] = info['url'];
    });
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.amber,
          ),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(color: Colors.purple, offset: Offset(2, 2)),
            BoxShadow(color: Colors.pink, offset: Offset(2, 2)),
          ],
          color: Color(0xffefefef),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  'Abilities',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              //Abilities list
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 6),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: abilityMap.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.purple, offset: Offset(1, 1)),
                        BoxShadow(color: Colors.pink, offset: Offset(1, 1)),
                      ],
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.amber,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(6),
                      title: Text(
                        '  ${namesList[index]}',
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Text('see more...  '),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AbilityPage(
                              name: namesList[index],
                              url: abilityMap[namesList[index]],
                            ),
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
    );
  }

  Widget getMovesWidget(data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.amber,
          ),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(color: Colors.purple, offset: Offset(2, 2)),
            BoxShadow(color: Colors.pink, offset: Offset(2, 2)),
          ],
          color: Color(0xffefefef),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  'Moves',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                separatorBuilder: (context, index) => SizedBox(height: 6),
                shrinkWrap: true,
                itemCount: data.moves.length,
                itemBuilder: (context, index) {
                  String namesCaps = data.moves[index].replaceFirst(
                      data.moves[index][0], data.moves[index][0].toUpperCase());
                  return Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: Colors.purple, offset: Offset(1, 1)),
                        BoxShadow(color: Colors.pink, offset: Offset(1, 1)),
                      ],
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.amber,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: ListTile(
                      title: Text(
                        namesCaps,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
